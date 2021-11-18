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
# success x failure emails settings
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
## parameters
###########################################
datasets = {
    'wb_gdp_per_capita' : {
        'job' : 'export_wb_gdp_per_capita', 
        'dwh_table' : 'dwh_landing.wb_gdp_per_capita'
    },
    'wb_income_share_10' : {
        'job' : 'export_wb_income_share_10', 
        'dwh_table' : 'dwh_landing.wb_income_share_10'
    },
    'wb_population_growth' : {
        'job' : 'export_wb_population_growth', 
        'dwh_table' : 'dwh_landing.wb_population_growth'
    },
    'wb_co2_emissions' : {
        'job' : 'export_wb_co2_emissions', 
        'dwh_table' : 'dwh_landing.wb_co2_emissions'
    },
    'lov_wb_countries' : {
        'job' : 'export_lov_wb_countries', 
        'dwh_table' : 'dwh_landing.lov_wb_countries'
    },
}

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
with DAG(dag_id=DAG_NAME, schedule_interval='0 15 * * *', catchup=False, start_date=days_ago(1), default_view='graph', orientation='TB') as dag:

    # dummy operators to keep the DAG nice n clean
    pg_truncate_finished = DummyOperator(task_id='dwh_drop_tables_finished', 
                                            trigger_rule = 'all_success',
                                            dag=dag)

    glue_jobs_finished = DummyOperator(task_id='glue_jobs_finished', 
                                            trigger_rule = 'all_success',
                                            dag=dag)

    # DWH - logs
    dwh_log_start = PostgresOperator(
        task_id="dwh_log_start",
        postgres_conn_id="aurora",
        sql="call dwh_adm.log_event('%s','%s','%s','%s', null, null);" % ('start', 'Airflow', DAG_NAME, '{{ run_id }}'),
        autocommit = True
    )

    # DWH - drop the landing tables (Spark will create new ones when loading data into Aurora)
    for dataset in datasets: 
        sql_command = "call dwh_adm.drop_table('%s');" % (datasets[dataset]['dwh_table'])
        truncate_task = PostgresOperator(
            task_id="dwh_drop_table_" + datasets[dataset]['dwh_table'],
            postgres_conn_id="aurora",
            sql=sql_command
        )
        truncate_task.set_upstream(dwh_log_start)
        truncate_task.set_downstream(pg_truncate_finished)

    # glue jobs
    for dataset in datasets: 
        export_glue_job_task = AwsGlueJobOperator(
                        task_id = 'glue_' + datasets[dataset]['job'] + '_job',
                        job_name = datasets[dataset]['job'],
                        region_name = REGION_NAME,
                        num_of_dpus = 2,
                        dag = dag
        )

        export_glue_job_task.set_upstream(pg_truncate_finished)
        export_glue_job_task.set_downstream(glue_jobs_finished)

    # DWH logging and notification emails
    for notif_type in SUCESS_FAIL_NOTIF:  
        # create success vs failure stream
        notif_stream = DummyOperator(task_id='stream_' + notif_type, 
                                                trigger_rule = SUCESS_FAIL_NOTIF[notif_type]['rule'],
                                                dag=dag)
        notif_stream.set_upstream(glue_jobs_finished)

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