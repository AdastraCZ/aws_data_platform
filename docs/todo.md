# TODO list 

This is the list of things we want to improve / implement next.

**Data Lake**

- Use Lake Formation (this will enable better table/columns access policies etc.)
- Checkout new AWS Glue DataBrew
- DQ framework Deequ - https://aws.amazon.com/blogs/big-data/test-data-quality-at-scale-with-deequ/
- Using Jupyter notebook for analysing data in data lake: https://docs.aws.amazon.com/sagemaker/latest/dg/nbi.html
- Implement a machine learning process using AWS SageMaker

**DWH**
- Implement a new DWH instance built on Redshift (also using Redshift spectrum)
- Checkout Aurora serverless

**Airflow**
- define DAG depencies
- Using AWS Secrets Manager for storing variables, connections