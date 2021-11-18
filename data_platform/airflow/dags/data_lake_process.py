from airflow import DAG
from airflow.providers.amazon.aws.operators.glue import AwsGlueJobOperator
from airflow.providers.amazon.aws.operators.glue_crawler import AwsGlueCrawlerOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
import boto3, botocore, logging, os, logging
from airflow.models import Variable

###########################################
## Constants
###########################################

# general config
REGION_NAME = "eu-central-1"
# AWS SES - email notif config
SES_CONFIGURATION_SET = "airflow"
SES_SENDER = "Airflow <robert.polakovic@adastragrp.com>"
# success x fail notifications
EMAIL_NOTIFS = {
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
    'jobs' : {
        'curated_wb_gdp_per_capita', 
        'curated_wb_income_share_10', 
        'curated_wb_population_growth',
        'curated_wb_co2_emissions',
        'curated_lov_wb_countries',
        #'curated_gdelt_event_type',
        #'curated_gdelt_actor_type',
        #'curated_gdelt_country_type'
        # be careful! these jobs are huuge and really pricey
        #'curated_gdelt_events',
        #'curated_gdelt_events_sql'
    },
    'crawlers' : {
        'curated_wb_gdp_per_capita', 
        'curated_wb_income_share_10', 
        'curated_wb_population_growth',
        'curated_wb_co2_emissions',
        'curated_lov_wb_countries',
        #'curated_gdelt_event_type',
        #'curated_gdelt_actor_type',
        #'curated_gdelt_country_type'
        # be careful! these jobs are huuge and really pricey
        #'curated_gdelt_events',
        #'curated_gdelt_events_sql'
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
with DAG(dag_id=DAG_NAME, schedule_interval='0 14 * * *', catchup=False, start_date=days_ago(1), default_view='graph', orientation='TB') as dag:

    # dummy operators to keep the DAG nice n clean
    curated_jobs_finished = DummyOperator(task_id='curated_jobs_finished', 
                                            trigger_rule = 'all_success',
                                            dag=dag)

    crawlers_finished = DummyOperator(task_id='crawlers_finished', 
                                            trigger_rule = 'all_success',
                                            dag=dag)

    # glue jobs
    for job_name in datasets['jobs']: 
        curated_glue_job_task = AwsGlueJobOperator(
                        task_id = job_name + '_job',
                        job_name = job_name,
                        region_name = REGION_NAME,
                        num_of_dpus = 1,
                        dag = dag
        )

        curated_glue_job_task.set_downstream(curated_jobs_finished)


    # glue jobs
    for cralwer_name in datasets['crawlers']: 
        curated_crawler_task = AwsGlueCrawlerOperator(
                        task_id=cralwer_name + '_crawler',
                        config = {"Name": cralwer_name},
                        dag=dag
        )

        curated_crawler_task.set_upstream(curated_jobs_finished)
        curated_crawler_task.set_downstream(crawlers_finished)


    # notification emails
    for notif_type in EMAIL_NOTIFS: 
        email_notif_task = PythonOperator(
            task_id='email_notification_' + notif_type,
            trigger_rule = EMAIL_NOTIFS[notif_type]['rule'],
            provide_context=True,
            python_callable=lambda dag_name=DAG_NAME, type=notif_type, **kwargs: send_email(dag_name, type, **kwargs),
            dag=dag
        )
        email_notif_task.set_upstream(crawlers_finished)