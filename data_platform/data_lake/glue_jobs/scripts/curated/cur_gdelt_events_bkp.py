'''
DO NOT USE

I have created this job just to test the speed of this Spark job comparing to cur_gdelt_events_sql!
'''
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import pytz
from datetime import datetime

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# adding timestamp audit column
def AddTimestamp(record):
    record["create_datetime_cet"] = datetime.utcnow().replace(tzinfo=pytz.timezone('Europe/Prague')) #timestamp of when we ran this.
    return record

datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "data_lake_raw", table_name = "gdelt_events", transformation_ctx = "datasource0")

timestamp_added = Map.apply(frame = datasource0, f = AddTimestamp)

applymapping1 = ApplyMapping.apply(frame = timestamp_added, mappings = [("globaleventid", "int", "global_event_id", "int"), ("day", "int", "day", "int"), ("monthyear", "int", "month_year", "int"), ("year", "int", "year", "string"), ("fractiondate", "float", "fraction_date", "float"), ("actor1code", "string", "actor1_code", "string"), ("actor1name", "string", "actor1_name", "string"), ("actor1countrycode", "string", "actor1_country_code", "string"), ("actor1knowngroupcode", "string", "actor1_known_group_code", "string"), ("actor1ethniccode", "string", "actor1_ethnic_code", "string"), ("actor1religion1code", "string", "actor1_religion1_code", "string"), ("actor1religion2code", "string", "actor1_religion2_code", "string"), ("actor1type1code", "string", "actor1_type1_code", "string"), ("actor1type2code", "string", "actor1_type2_code", "string"), ("actor1type3code", "string", "actor1_type3_code", "string"), ("actor2code", "string", "actor2_code", "string"), ("actor2name", "string", "actor2_name", "string"), ("actor2countrycode", "string", "actor2_country_code", "string"), ("actor2knowngroupcode", "string", "actor2_known_group_code", "string"), ("actor2ethniccode", "string", "actor2_ethnic_code", "string"), ("actor2religion1code", "string", "actor2_religion1_code", "string"), ("actor2religion2code", "string", "actor2_religion2_code", "string"), ("actor2type1code", "string", "actor2_type1_code", "string"), ("actor2type2code", "string", "actor2_type2_code", "string"), ("actor2type3code", "string", "actor2_type3_code", "string"), ("isrootevent", "boolean", "is_root_event", "boolean"), ("eventcode", "string", "event_code", "string"), ("eventbasecode", "string", "event_base_code", "string"), ("eventrootcode", "string", "event_root_code", "string"), ("quadclass", "int", "quad_class", "int"), ("goldsteinscale", "float", "goldstein_scale", "float"), ("nummentions", "int", "num_mentions", "int"), ("numsources", "int", "num_sources", "int"), ("numarticles", "int", "num_articles", "int"), ("avgtone", "float", "avg_tone", "float"), ("actor1geo_type", "int", "actor1_geo_type", "int"), ("actor1geo_fullname", "string", "actor1_geo_full_name", "string"), ("actor1geo_countrycode", "string", "actor1_geo_country_code", "string"), ("actor1geo_adm1code", "string", "actor1_geo_adm1_code", "string"), ("actor1geo_lat", "float", "actor1_geo_lat", "float"), ("actor1geo_long", "float", "actor1_geo_long", "string"), ("actor1geo_featureid", "int", "actor1_geo_feature_id", "int"), ("actor2geo_type", "int", "actor2_geo_type", "int"), ("actor2geo_fullname", "string", "actor2_geo_full_name", "string"), ("actor2geo_countrycode", "string", "actor2_geo_country_code", "string"), ("actor2geo_adm1code", "string", "actor2_geo_adm1_code", "string"), ("actor2geo_lat", "float", "actor2_geo_lat", "float"), ("actor2geo_long", "float", "actor2_geo_long", "string"), ("actor2geo_featureid", "int", "actor2_geo_feature_id", "int"), ("actiongeo_type", "int", "action_geo_type", "int"), ("actiongeo_fullname", "string", "action_geo_full_name", "string"), ("actiongeo_countrycode", "string", "action_geo_country_code", "string"), ("actiongeo_adm1code", "string", "action_geo_adm1_code", "string"), ("actiongeo_lat", "float", "action_geo_lat", "float"), ("actiongeo_long", "float", "action_geo_long", "string"), ("actiongeo_featureid", "int", "action_geo_feature_id", "int"), ("dateadded", "int", "date_added", "int"), ("sourceurl", "string", "source_url", "string"), ("create_datetime_cet", "timestamp", "create_datetime_cet", "timestamp")], transformation_ctx = "applymapping1")

dropnullfields3 = DropNullFields.apply(frame = applymapping1, transformation_ctx = "dropnullfields3")

final_DF = dropnullfields3.toDF()

final_DF.write \
  .mode("overwrite") \
  .format("parquet") \
  .partitionBy("year") \
  .save("s3://adastracz-demo-datalake-curated/gdelt_events/")

job.commit()