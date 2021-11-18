import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# processing
datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "data_lake_curated", table_name = "wb_income_share_10", transformation_ctx = "datasource0")
applymapping1 = ApplyMapping.apply(frame = datasource0, mappings = [("country_iso_3_code", "string", "country_iso_3_code", "string"), ("val", "double", "val", "double"), ("valid_from_date_cet", "date", "valid_from_date_cet", "date"), ("valid_to_date_cet", "date", "valid_to_date_cet", "date")], transformation_ctx = "applymapping1")
# resolve data
resolvedData = applymapping1.resolveChoice(specs = [('val','cast:double')])
# dropping null records
df_dropfields1 = DropNullFields.apply(frame = resolvedData, transformation_ctx = "dropnullfields3").toDF()
# creating tables
df_dropfields1.createOrReplaceTempView('wb_income_share_10')

# I wanted to test SQL engine, SQL syntax
statement = """
select 
  country_iso_3_code,
  val,
  valid_from_date_cet,
  valid_to_date_cet,
  from_utc_timestamp(current_timestamp(), 'Europe/Prague') as create_datetime_cet
from wb_income_share_10
"""
# run the SQL statement
df_sql = spark.sql(statement)
# convert DataFrame to DynamicFrame
my_dyf = DynamicFrame.fromDF(df_sql, glueContext, "my_dyf")

datasink4 = glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=my_dyf,
    catalog_connection='aurora',
    connection_options={"dbtable": 'dwh_landing.wb_income_share_10', "database": "postgres"},
    transformation_ctx="datasink4"
)

job.commit()