import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from datetime import datetime

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "data_lake_raw", table_name = "gdelt_events", transformation_ctx = "datasource0")

applymapping1 = ApplyMapping.apply(frame = datasource0, mappings = [("globaleventid", "int", "global_event_id", "int"), ("day", "int", "day", "int"), ("monthyear", "int", "month_year", "int"), ("year", "int", "year", "string"), ("fractiondate", "float", "fraction_date", "float"), ("actor1code", "string", "actor1_code", "string"), ("actor1name", "string", "actor1_name", "string"), ("actor1countrycode", "string", "actor1_country_code", "string"), ("actor1knowngroupcode", "string", "actor1_known_group_code", "string"), ("actor1ethniccode", "string", "actor1_ethnic_code", "string"), ("actor1religion1code", "string", "actor1_religion1_code", "string"), ("actor1religion2code", "string", "actor1_religion2_code", "string"), ("actor1type1code", "string", "actor1_type1_code", "string"), ("actor1type2code", "string", "actor1_type2_code", "string"), ("actor1type3code", "string", "actor1_type3_code", "string"), ("actor2code", "string", "actor2_code", "string"), ("actor2name", "string", "actor2_name", "string"), ("actor2countrycode", "string", "actor2_country_code", "string"), ("actor2knowngroupcode", "string", "actor2_known_group_code", "string"), ("actor2ethniccode", "string", "actor2_ethnic_code", "string"), ("actor2religion1code", "string", "actor2_religion1_code", "string"), ("actor2religion2code", "string", "actor2_religion2_code", "string"), ("actor2type1code", "string", "actor2_type1_code", "string"), ("actor2type2code", "string", "actor2_type2_code", "string"), ("actor2type3code", "string", "actor2_type3_code", "string"), ("isrootevent", "boolean", "is_root_event", "boolean"), ("eventcode", "string", "event_code", "string"), ("eventbasecode", "string", "event_base_code", "string"), ("eventrootcode", "string", "event_root_code", "string"), ("quadclass", "int", "quad_class", "int"), ("goldsteinscale", "float", "goldstein_scale", "float"), ("nummentions", "int", "num_mentions", "int"), ("numsources", "int", "num_sources", "int"), ("numarticles", "int", "num_articles", "int"), ("avgtone", "float", "avg_tone", "float"), ("actor1geo_type", "int", "actor1_geo_type", "int"), ("actor1geo_fullname", "string", "actor1_geo_full_name", "string"), ("actor1geo_countrycode", "string", "actor1_geo_country_code", "string"), ("actor1geo_adm1code", "string", "actor1_geo_adm1_code", "string"), ("actor1geo_lat", "float", "actor1_geo_lat", "float"), ("actor1geo_long", "float", "actor1_geo_long", "string"), ("actor1geo_featureid", "int", "actor1_geo_feature_id", "int"), ("actor2geo_type", "int", "actor2_geo_type", "int"), ("actor2geo_fullname", "string", "actor2_geo_full_name", "string"), ("actor2geo_countrycode", "string", "actor2_geo_country_code", "string"), ("actor2geo_adm1code", "string", "actor2_geo_adm1_code", "string"), ("actor2geo_lat", "float", "actor2_geo_lat", "float"), ("actor2geo_long", "float", "actor2_geo_long", "string"), ("actor2geo_featureid", "int", "actor2_geo_feature_id", "int"), ("actiongeo_type", "int", "action_geo_type", "int"), ("actiongeo_fullname", "string", "action_geo_full_name", "string"), ("actiongeo_countrycode", "string", "action_geo_country_code", "string"), ("actiongeo_adm1code", "string", "action_geo_adm1_code", "string"), ("actiongeo_lat", "float", "action_geo_lat", "float"), ("actiongeo_long", "float", "action_geo_long", "string"), ("actiongeo_featureid", "int", "action_geo_feature_id", "int"), ("dateadded", "int", "date_added", "int"), ("sourceurl", "string", "source_url", "string")], transformation_ctx = "applymapping1")

df_dropnullfields3 = DropNullFields.apply(frame = applymapping1, transformation_ctx = "dropnullfields3").toDF()

# creating tables
df_dropnullfields3.createOrReplaceTempView('gdelt_events')

# I wanted to test SQL engine, SQL syntax
statement = """
select 
  global_event_id,
  day,
  month_year,
  year,
  fraction_date,
  actor1_code,
  actor1_name,
  actor1_country_code,
  actor1_known_group_code,
  actor1_ethnic_code,
  actor1_religion1_code,
  actor1_religion2_code,
  actor1_type1_code,
  actor1_type2_code,
  actor1_type3_code,
  actor2_code,
  actor2_name,
  actor2_country_code,
  actor2_known_group_code,
  actor2_ethnic_code,
  actor2_religion1_code,
  actor2_religion2_code,
  actor2_type1_code,
  actor2_type2_code,
  actor2_type3_code,
  is_root_event,
  event_code,
  event_base_code,
  event_root_code,
  quad_class,
  goldstein_scale,
  num_mentions,
  num_sources,
  num_articles,
  avg_tone,
  actor1_geo_type,
  actor1_geo_full_name,
  actor1_geo_country_code,
  actor1_geo_adm1_code,
  actor1_geo_lat,
  actor1_geo_long,
  actor1_geo_feature_id,
  actor2_geo_type,
  actor2_geo_full_name,
  actor2_geo_country_code,
  actor2_geo_adm1_code,
  actor2_geo_lat,
  actor2_geo_long,
  actor2_geo_feature_id,
  action_geo_type,
  action_geo_full_name,
  action_geo_country_code,
  action_geo_adm1_code,
  action_geo_lat,
  action_geo_long,
  action_geo_feature_id,
  date_added,
  source_url,
  from_utc_timestamp(current_timestamp(), 'Europe/Prague') as create_datetime_cet
from gdelt_events
"""
# run the SQL statement
df_sql = spark.sql(statement)


df_sql.write \
  .mode("overwrite") \
  .format("parquet") \
  .partitionBy("year") \
  .save("s3://adastracz-demo-datalake-curated/gdelt_events_sql/")

job.commit()