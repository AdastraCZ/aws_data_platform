CREATE EXTERNAL TABLE IF NOT EXISTS data_lake_raw.gdelt_actor_type (
  `type_code` string,
  `label` string) 
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
  WITH SERDEPROPERTIES (
    'serialization.format' = '	',
    'field.delim' = ',',
    'skip.header.line.count' = '1'
    ) 
  LOCATION 's3://adastracz-demo-datalake-raw/gdelt_project/actor_types/';