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

# adding timestamp audit column
def AddTimestamp(record):
    record["create_datetime_utc"] = datetime.today() #timestamp of when we ran this.
    return record

datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "data_lake_raw", table_name = "lov_countries", transformation_ctx = "datasource0")
applymapping1 = ApplyMapping.apply(frame = datasource0, mappings = [("id", "string", "country_iso_3_code", "string"), ("iso2code", "string", "country_iso_2_code", "string"), ("name", "string", "name", "string"), ("region.value", "string", "region_name", "string"), ("region.iso2code", "string", "region_iso_2_code", "string"), ("adminregion.value", "string", "admin_region_name", "string"), ("adminregion.iso2code", "string", "admin_region_iso_2_code", "string"), ("incomelevel.id", "string", "income_level", "string"), ("incomelevel.iso2code", "string", "income_level_iso_2_code", "string"), ("lendingtype.id", "string", "lending_type", "string"), ("lendingtype.iso2code", "string", "lending_type_iso_2_code", "string"), ("capitalcity", "string", "capital_city", "string"), ("longitude", "string", "long", "double"), ("latitude", "string", "lat", "double")], transformation_ctx = "applymapping1")
# dropping null records
dropnullfields3 = DropNullFields.apply(frame = applymapping1, transformation_ctx = "dropnullfields3")
# adding timestamp column
mapped_DF = Map.apply(frame = dropnullfields3, f = AddTimestamp).toDF()

mapped_DF.write \
  .mode("overwrite") \
  .format("parquet") \
  .save("s3://adastracz-demo-datalake-curated/lov_wb_countries/")

job.commit()