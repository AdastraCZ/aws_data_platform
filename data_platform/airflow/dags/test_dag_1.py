from airflow import DAG
from airflow.providers.amazon.aws.operators.glue import AwsGlueJobOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
import boto3, botocore, logging,os, logging
from airflow.models import Variable
import time

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
def sleep_my_baby():
    time.sleep(5)

###########################################
## DAG
###########################################
with DAG(dag_id=DAG_NAME, schedule_interval='0 16 * * *', catchup=False, start_date=days_ago(1), default_view='graph', orientation='TB') as dag:

    task1 = PythonOperator(
            task_id='task1',
            provide_context=False,
            python_callable=sleep_my_baby,
            dag=dag   
            )

    task2 = PythonOperator(
            task_id='task1',
            provide_context=False,
            python_callable=sleep_my_baby,
            dag=dag   
            )

    task3 = PythonOperator(
            task_id='task1',
            provide_context=False,
            python_callable=sleep_my_baby,
            dag=dag   
            )