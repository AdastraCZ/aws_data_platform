#!/bin/bash
set -e

aws s3 rm s3://adastracz-demo-airflow/dags/ --recursive

aws s3 sync ./data_platform/airflow/dags/ s3://adastracz-demo-airflow/dags/
