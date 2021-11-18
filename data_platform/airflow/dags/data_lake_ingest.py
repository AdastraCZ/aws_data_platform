from airflow import DAG
from airflow.providers.amazon.aws.operators.glue_crawler import AwsGlueCrawlerOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
from dateutil.relativedelta import relativedelta
import boto3, botocore, tempfile, logging, requests, json, os, logging
from airflow.models import Variable

###########################################
## Constants
###########################################

# general config
GLUE_IAM_ROLE = "glue-role"
REGION_NAME = "eu-central-1"
RAW_BUCKET = 'adastracz-demo-datalake-raw'
# AWS SES - email notif config
SES_CONFIGURATION_SET = "airflow"
SES_SENDER = "Airflow <robert.polakovic@adastragrp.com>"
# API data config
YEARS_TO_DOWNLOAD = 41
# success x failure emails settings
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
## Source API parameters
###########################################
wb_datasets = {
    'wb_gdp_per_capita' : {
        'name' : 'wb_gdp_per_capita',
        'type' : 'data',
        'description' : 'GDP per capita, PPP (current international $)',
        's3_prefix' : 'world_bank/gdp_per_capita/%s/',
        'url' : 'https://api.worldbank.org/v2/country/all/indicator/NY.GDP.PCAP.PP.CD?date=%s&per_page=400&format=json',
        'glue_crawler' : 'raw_gdp_per_capita'
    },
    #https://data.worldbank.org/indicator/SI.DST.10TH.10?view=chart
    'wb_income_share_10' : {
        'name' : 'wb_income_share_10',
        'type' : 'data',
        'description' : 'Income share held by highest 10%',
        's3_prefix' : 'world_bank/income_share_10/%s/',
        'url' : 'https://api.worldbank.org/v2/country/all/indicator/SI.DST.10TH.10?date=%s&per_page=400&format=json',
        'glue_crawler' : 'raw_income_share_10'
    },
    'wb_population_growth' : {
        'name' : 'wb_population_growth',
        'type' : 'data',
        'description' : 'Population growth (annual %)',
        's3_prefix' : 'world_bank/population_growth/%s/',
        'url' : 'https://api.worldbank.org/v2/country/all/indicator/SP.POP.GROW?date=%s&per_page=400&format=json',
        'glue_crawler' : 'raw_population_growth'
    },
    'wb_co2_emissions' : {
        'name' : 'wb_co2_emissions',
        'type' : 'data',
        'description' : 'CO2 emissions (kiloton)',
        's3_prefix' : 'world_bank/co2_emissions/%s/',
        'url' : 'https://api.worldbank.org/v2/country/all/indicator/EN.ATM.CO2E.KT?date=%s&per_page=400&format=json',
        'glue_crawler' : 'raw_co2_emissions'
    },
    'lov_wb_countries' : {
        'name' : 'lov_wb_countries',
        'type' : 'lov',
        'description' : 'Country details',
        's3_prefix' : 'world_bank/lov_countries/',
        'url' : 'https://api.worldbank.org/v2/country?format=json&per_page=400&page=1',
        'glue_crawler' : 'raw_lov_countries'
    },
}

###########################################
## Helper functions
###########################################
def request_data_json(dataset, year):
    '''
    sends request to API and transform the response to JSON
    '''
    # lov datasets do not have time series
    if wb_datasets[dataset]['type'] == 'lov':
        url = wb_datasets[dataset]['url']
    else: 
        url = wb_datasets[dataset]['url'] % (year)
    logging.info('###  calling API: ' + url)
    r = requests.get(url)
    if r.status_code != 200:
        raise Exception(r.text)
    return r.json()

def process_file(data, dataset, year):
    '''
    '''
    with tempfile.TemporaryFile(mode='w+b') as file:
        for item in data[1]:
            file.write(json.dumps(item).encode('UTF-8'))
            file.write('\n'.encode('UTF-8'))
        file.seek(0)
        save_file_on_s3(file, dataset, year)
    return file

def save_file_on_s3(file, dataset, year):
    '''
    save data file to s3
    '''
    s3 = boto3.resource('s3')
    # lov datasets do not have time series
    if wb_datasets[dataset]['type'] == 'lov':
        s3_prefix = wb_datasets[dataset]['s3_prefix']
    else:
        s3_prefix = wb_datasets[dataset]['s3_prefix'] % (year)
    s3_key = s3_prefix + 'data.json'
    delete_s3_prefix(RAW_BUCKET, s3_prefix)
    #s3.Object(RAW_BUCKET, s3_key).put(Body=(bytes(json.dumps(file).encode('UTF-8'))))
    s3.Object(RAW_BUCKET, s3_key).put(Body=file)
    file_path = 's3://' + RAW_BUCKET + '/' + s3_prefix
    logging.info('###  data saved to: ' + file_path)

def get_dataset(dataset, execution_date, **kwargs):
    '''
    get the whole dataset for the last x years
    '''
    # we want to download only 1 copy if the dataset is lov
    if wb_datasets[dataset]['type'] == 'lov':
        years_to_process = 1
    else: 
        # get World Bank data for the last 20 years
        years_to_process = YEARS_TO_DOWNLOAD
    for x in range(years_to_process):
        year = (execution_date - relativedelta(years=x+1)).strftime("%Y")
        logging.info('###  processing data : ' + dataset + ', year:' + year)
        process_file(request_data_json(dataset, year), dataset, year)

def delete_s3_prefix(bucket, prefix):
    '''
    deletes everything inside s3 path
    '''
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucket)
    bucket.objects.filter(Prefix=prefix).delete()

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
with DAG(dag_id=DAG_NAME, schedule_interval='0 12 * * *', catchup=False, start_date=days_ago(1), default_view='graph', orientation='TB') as dag:

    # dummy operators to keep the DAG nice n clean
    api_data_download_finished = DummyOperator(task_id='wb_api_data_download_finished', 
                                                trigger_rule = 'all_success',
                                                dag=dag)

    crawlers_finished = DummyOperator(task_id='crawlers_finished', 
                                                trigger_rule = 'all_success',
                                                dag=dag)

    # getting World Bank api data in a loop - metadata defined in the  wb_datasets set above
    for wb_set in wb_datasets: 
        get_api_data = PythonOperator(
            task_id='get_api_' + wb_datasets[wb_set]['name'],
            provide_context=True,
            python_callable=lambda dataset=wb_datasets[wb_set]['name'], **kwargs: get_dataset(dataset, **kwargs),
            dag=dag
        )

        get_api_data.set_downstream(api_data_download_finished)

    # crawl the downloaded data
    for wb_set in wb_datasets: 
        crawl_data = AwsGlueCrawlerOperator(
            task_id='crawl_' + wb_datasets[wb_set]['name'],
            config = {"Name": wb_datasets[wb_set]['glue_crawler']},
            dag=dag
        )

        crawl_data.set_upstream(api_data_download_finished)
        crawl_data.set_downstream(crawlers_finished)

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
