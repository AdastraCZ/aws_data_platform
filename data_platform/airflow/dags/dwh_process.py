from airflow import DAG
from airflow.providers.amazon.aws.operators.glue import AwsGlueJobOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
import boto3, botocore, logging,os, logging
from airflow.models import Variable

###########################################
## Constants
###########################################

# general config
REGION_NAME = "eu-central-1"
# AWS SES - email notif config
SES_CONFIGURATION_SET = "airflow"
SES_SENDER = "Airflow <robert.polakovic@adastragrp.com>"
# API data config
SUCESS_FAIL_NOTIF = {
    'success' : {
        'rule' : 'all_success'
    },
    'failure' : {
        'rule' : 'one_failed'
    }
}

DAG_NAME = os.path.basename(__file__).replace(".py", "")

###########################################
## Helper functions
###########################################

# email notification function
def send_email(dag_name, type, **kwargs):

    client = boto3.client('ses',region_name=REGION_NAME)
    # getting recipients from Airflow variables
    recipients = list(Variable.get("emails").split(","))
    # templates creating in Terraform earlier
    template = 'AirflowSuccess' if type == 'success' else 'AirflowFailure'

    try:
        response = client.send_templated_email(
            Source = SES_SENDER,
            Destination = {
                'ToAddresses': recipients,
            },
            Template = template,
            TemplateData='{ \"dag\":\"' + dag_name + '\" }'
        )

    except botocore.exceptions.ClientError as e:
        logging.info(e.response['Error']['Message'])
    else:
        logging.info("Email sent! Message ID:")
        logging.info(response['MessageId'])

###########################################
## DAG
###########################################
with DAG(dag_id=DAG_NAME, schedule_interval='0 16 * * *', catchup=False, start_date=days_ago(1), default_view='graph', orientation='TB') as dag:

    # dummy operators to keep the DAG nice n clean
    dwh_mappings_finished = DummyOperator(task_id='dwh_mappings_finished', 
                                            trigger_rule = 'all_success',
                                            dag=dag)

    # DWH - logs
    dwh_log_start = PostgresOperator(
        task_id="dwh_log_start",
        postgres_conn_id="aurora",
        sql="call dwh_adm.log_event('%s','%s','%s','%s', null, null);" % ('start', 'Airflow', DAG_NAME, '{{ run_id }}'),
        autocommit = True
    )

    # DWH mappings
    dwh_country_overview_map = PostgresOperator(
        task_id="dwh_country_overview_map",
        postgres_conn_id="aurora",
        sql="call dwh_master.country_overview_map();",
        autocommit = True
    )
    dwh_country_overview_map.set_upstream(dwh_log_start)
    dwh_country_overview_map.set_downstream(dwh_mappings_finished)

    dwh_region_overview_map = PostgresOperator(
        task_id="dwh_region_overview_map",
        postgres_conn_id="aurora",
        sql="call dwh_master.region_overview_map();",
        autocommit = True
    )
    dwh_region_overview_map.set_upstream(dwh_log_start)
    dwh_region_overview_map.set_downstream(dwh_mappings_finished)

    dwh_world_overview_map = PostgresOperator(
        task_id="dwh_world_overview_map",
        postgres_conn_id="aurora",
        sql="call dwh_master.world_overview_map();",
        autocommit = True
    )
    dwh_world_overview_map.set_upstream(dwh_log_start)
    dwh_world_overview_map.set_downstream(dwh_mappings_finished)

    # DWH logging and notification emails
    for notif_type in SUCESS_FAIL_NOTIF:  
        # create success vs failure stream
        notif_stream = DummyOperator(task_id='stream_' + notif_type, 
                                                trigger_rule = SUCESS_FAIL_NOTIF[notif_type]['rule'],
                                                dag=dag)
        notif_stream.set_upstream(dwh_mappings_finished)

        # Log DWH event
        dwh_log_finish = PostgresOperator(
            task_id="dwh_log_finish_" + notif_type,
            postgres_conn_id="aurora",
            sql="call dwh_adm.log_event('%s','%s','%s','%s', null, null);" % (notif_type, 'Airflow', DAG_NAME, '{{ run_id }}'),
            autocommit = True
        )
        dwh_log_finish.set_upstream(notif_stream)

        # Send email
        email_notif_task = PythonOperator(
            task_id='email_notification_' + notif_type,
            provide_context=True,
            python_callable=lambda dag_name=DAG_NAME, type=notif_type, **kwargs: send_email(dag_name, type, **kwargs),
            dag=dag
        )
        email_notif_task.set_upstream(dwh_log_finish)