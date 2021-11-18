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
datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "data_lake_raw", table_name = "income_share_10", transformation_ctx = "datasource0")
applymapping1 = ApplyMapping.apply(frame = datasource0, mappings = [("countryiso3code", "string", "country_iso_3_code", "string"), ("value", "double", "val", "double"), ("partition_0", "string", "year", "string")], transformation_ctx = "applymapping1")
# resolve data
resolvedData = applymapping1.resolveChoice(specs = [('val','cast:double')])
# dropping null records
df_dropfields1 = DropNullFields.apply(frame = resolvedData, transformation_ctx = "dropnullfields3").toDF()
# creating tables
df_dropfields1.createOrReplaceTempView('raw_income_share_10')

# I wanted to test SQL engine, SQL syntax
statement = """
select 
  country_iso_3_code,
  val,
  to_date(concat('01-01-',year), 'dd-MM-yyyy') as valid_from_date_cet,
  ifnull(date_add(to_date(concat('01-01-',lag(year) OVER (PARTITION BY country_iso_3_code ORDER BY year DESC)), 'dd-MM-yyyy'), -1), to_date(concat('31-12-',year),'dd-MM-yyyy'))  as valid_to_date_cet,
  from_utc_timestamp(current_timestamp(), 'Europe/Prague') as create_datetime_cet,
  year
from raw_income_share_10
where val is not null
"""
# run the SQL statement
df_sql = spark.sql(statement)

df_sql.write \
  .mode("overwrite") \
  .format("parquet") \
  .partitionBy("year") \
  .save("s3://adastracz-demo-datalake-curated/wb_income_share_10/")

job.commit()