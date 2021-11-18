import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from datetime import datetime

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# processing
datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "data_lake_raw", table_name = "gdelt_actor_type", transformation_ctx = "datasource0")
applymapping1 = ApplyMapping.apply(frame = datasource0, mappings = [("type_code", "string", "actor_type_code", "string"), ("label", "string", "actor_type_desc", "string")], transformation_ctx = "applymapping1")
# dropping null records
df_dropfields1 = DropNullFields.apply(frame = applymapping1, transformation_ctx = "dropnullfields3").toDF()
# creating tables
df_dropfields1.createOrReplaceTempView('gdelt_actor_type')

# I wanted to test SQL engine, SQL syntax
statement = """
select 
  actor_type_code,
  actor_type_desc,
  from_utc_timestamp(current_timestamp(), 'Europe/Prague') as create_datetime_cet
from gdelt_actor_type
where actor_type_code is not null
"""
# run the SQL statement
df_sql = spark.sql(statement)

df_sql.write \
  .mode("overwrite") \
  .format("parquet") \
  .save("s3://adastracz-demo-datalake-curated/gdelt_actor_type/")

job.commit()