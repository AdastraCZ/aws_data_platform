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
datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "data_lake_curated", table_name = "lov_wb_countries", transformation_ctx = "datasource0")
applymapping1 = ApplyMapping.apply(frame = datasource0, mappings = [ \
("country_iso_3_code", "string", "country_iso_3_code", "string"), \
("country_iso_2_code", "string", "country_iso_2_code", "string"), \
("name", "string", "name", "string"), \
("region_name", "string", "region_name", "string"), \
("region_iso_2_code", "string", "region_iso_2_code", "string"), \
("admin_region_name", "string", "admin_region_name", "string"), \
("admin_region_iso_2_code", "string", "admin_region_iso_2_code", "string"), \
("income_level", "string", "income_level", "string"), \
("income_level_iso_2_code", "string", "income_level_iso_2_code", "string"), \
("lending_type", "string", "lending_type", "string"), \
("lending_type_iso_2_code", "string", "lending_type_iso_2_code", "string"), \
("capital_city", "string", "capital_city", "string"), \
("long", "string", "long", "double"), \
("lat", "string", "lat", "double")
], transformation_ctx = "applymapping1")

# dropping null records
df_dropfields1 = DropNullFields.apply(frame = applymapping1, transformation_ctx = "dropnullfields3").toDF()
# creating tables
df_dropfields1.createOrReplaceTempView('lov_wb_countries')

# I wanted to test SQL engine, SQL syntax
statement = """
select 
  country_iso_3_code,
  country_iso_2_code,
  name,
  region_name,
  region_iso_2_code,
  admin_region_name,
  admin_region_iso_2_code,
  income_level,
  income_level_iso_2_code, 
  lending_type,
  lending_type_iso_2_code,
  capital_city,
  long,
  lat,
  from_utc_timestamp(current_timestamp(), 'Europe/Prague') as create_datetime_cet
from lov_wb_countries
"""
# run the SQL statement
df_sql = spark.sql(statement)
# convert DataFrame to DynamicFrame
my_dyf = DynamicFrame.fromDF(df_sql, glueContext, "my_dyf")

datasink4 = glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=my_dyf,
    catalog_connection='aurora',
    connection_options={"dbtable": 'dwh_landing.lov_wb_countries', "database": "postgres"},
    transformation_ctx="datasink4"
)

job.commit()