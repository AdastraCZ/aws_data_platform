resource "aws_glue_catalog_table" "gdelt_event_type" {
  name          = "gdelt_event_type"
  database_name = var.curated_data_lake_database
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "${var.curated_data_lake_bucket}/gdelt_event_type/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "gdelt_event_type"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "event_type_code"
      type = "string"
    }

    columns {
      name = "event_type_desc"
      type = "string"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}

resource "aws_glue_catalog_table" "gdelt_actor_type" {
  name          = "gdelt_actor_type"
  database_name = var.curated_data_lake_database
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "${var.curated_data_lake_bucket}/gdelt_actor_type/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "gdelt_actor_type"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "actor_type_code"
      type = "string"
    }

    columns {
      name = "actor_type_desc"
      type = "string"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}

resource "aws_glue_catalog_table" "gdelt_country_type" {
  name          = "gdelt_country_type"
  database_name = var.curated_data_lake_database
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "${var.curated_data_lake_bucket}/gdelt_country_type/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "gdelt_country_type"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "country_type_code"
      type = "string"
    }

    columns {
      name = "country_type_desc"
      type = "string"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}

resource "aws_glue_catalog_table" "gdelt_events" {
  name          = "gdelt_events"
  database_name = var.curated_data_lake_database
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  partition_keys {
    name = "year"
    type = "string"
  }

  storage_descriptor {
    location      = "${var.curated_data_lake_bucket}/gdelt_events/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "gdelt_events"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "global_event_id"
      type = "int"
    }

    columns {
      name = "day"
      type = "int"
    }

    columns {
      name = "month_year"
      type = "int"
    }

    columns {
      name = "fraction_date"
      type = "float"
    }

    columns {
      name = "actor1_code"
      type = "string"
    }

    columns {
      name = "actor1_name"
      type = "string"
    }

    columns {
      name = "actor1_country_code"
      type = "string"
    }

    columns {
      name = "actor1_known_group_code"
      type = "string"
    }

    columns {
      name = "actor1_ethnic_code"
      type = "string"
    }


    columns {
      name = "actor1_religion1_code"
      type = "string"
    }


    columns {
      name = "actor1_religion2_code"
      type = "string"
    }


    columns {
      name = "actor1_type1_code"
      type = "string"
    }


    columns {
      name = "actor1_type2_code"
      type = "string"
    }


    columns {
      name = "actor1_type3_code"
      type = "string"
    }

    columns {
      name = "actor2_code"
      type = "string"
    }

    columns {
      name = "actor2_name"
      type = "string"
    }

    columns {
      name = "actor2_country_code"
      type = "string"
    }

    columns {
      name = "actor2_known_group_code"
      type = "string"
    }

    columns {
      name = "actor2_ethnic_code"
      type = "string"
    }


    columns {
      name = "actor2_religion1_code"
      type = "string"
    }


    columns {
      name = "actor2_religion2_code"
      type = "string"
    }


    columns {
      name = "actor2_type1_code"
      type = "string"
    }


    columns {
      name = "actor2_type2_code"
      type = "string"
    }


    columns {
      name = "actor2_type3_code"
      type = "string"
    }


    columns {
      name = "is_root_event"
      type = "boolean"
    }


    columns {
      name = "event_code"
      type = "string"
    }


    columns {
      name = "event_base_code"
      type = "string"
    }


    columns {
      name = "event_root_code"
      type = "string"
    }


    columns {
      name = "quad_class"
      type = "int"
    }


    columns {
      name = "goldstein_scale"
      type = "float"
    }


    columns {
      name = "num_mentions"
      type = "int"
    }


    columns {
      name = "num_sources"
      type = "int"
    }


    columns {
      name = "num_articles"
      type = "int"
    }


    columns {
      name = "avg_tone"
      type = "float"
    }


    columns {
      name = "actor1_geo_type"
      type = "int"
    }


    columns {
      name = "actor1_geo_full_name"
      type = "string"
    }


    columns {
      name = "actor1_geo_country_code"
      type = "string"
    }


    columns {
      name = "actor1_geo_adm1_code"
      type = "string"
    }


    columns {
      name = "actor1_geo_lat"
      type = "float"
    }


    columns {
      name = "actor1_geo_long"
      type = "string"
    }


    columns {
      name = "actor1_geo_feature_id"
      type = "int"
    }

    columns {
      name = "actor2_geo_type"
      type = "int"
    }


    columns {
      name = "actor2_geo_full_name"
      type = "string"
    }


    columns {
      name = "actor2_geo_country_code"
      type = "string"
    }


    columns {
      name = "actor2_geo_adm1_code"
      type = "string"
    }


    columns {
      name = "actor2_geo_lat"
      type = "float"
    }


    columns {
      name = "actor2_geo_long"
      type = "string"
    }


    columns {
      name = "actor2_geo_feature_id"
      type = "int"
    }


    columns {
      name = "action_geo_type"
      type = "int"
    }


    columns {
      name = "action_geo_full_name"
      type = "string"
    }


    columns {
      name = "action_geo_country_code"
      type = "string"
    }


    columns {
      name = "action_geo_adm1_code"
      type = "string"
    }


    columns {
      name = "action_geo_lat"
      type = "float"
    }


    columns {
      name = "action_geo_long"
      type = "string"
    }

    columns {
      name = "action_geo_feature_id"
      type = "int"
    }

    columns {
      name = "date_added"
      type = "int"
    }

    columns {
      name = "source_url"
      type = "string"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}

########################################


resource "aws_glue_catalog_table" "gdelt_events_sql" {
  name          = "gdelt_events_sql"
  database_name = var.curated_data_lake_database
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  partition_keys {
    name = "year"
    type = "string"
  }

  storage_descriptor {
    location      = "${var.curated_data_lake_bucket}/gdelt_events_sql/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "gdelt_events_sql"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "global_event_id"
      type = "int"
    }

    columns {
      name = "day"
      type = "int"
    }

    columns {
      name = "month_year"
      type = "int"
    }

    columns {
      name = "fraction_date"
      type = "float"
    }

    columns {
      name = "actor1_code"
      type = "string"
    }

    columns {
      name = "actor1_name"
      type = "string"
    }

    columns {
      name = "actor1_country_code"
      type = "string"
    }

    columns {
      name = "actor1_known_group_code"
      type = "string"
    }

    columns {
      name = "actor1_ethnic_code"
      type = "string"
    }


    columns {
      name = "actor1_religion1_code"
      type = "string"
    }


    columns {
      name = "actor1_religion2_code"
      type = "string"
    }


    columns {
      name = "actor1_type1_code"
      type = "string"
    }


    columns {
      name = "actor1_type2_code"
      type = "string"
    }


    columns {
      name = "actor1_type3_code"
      type = "string"
    }

    columns {
      name = "actor2_code"
      type = "string"
    }

    columns {
      name = "actor2_name"
      type = "string"
    }

    columns {
      name = "actor2_country_code"
      type = "string"
    }

    columns {
      name = "actor2_known_group_code"
      type = "string"
    }

    columns {
      name = "actor2_ethnic_code"
      type = "string"
    }


    columns {
      name = "actor2_religion1_code"
      type = "string"
    }


    columns {
      name = "actor2_religion2_code"
      type = "string"
    }


    columns {
      name = "actor2_type1_code"
      type = "string"
    }


    columns {
      name = "actor2_type2_code"
      type = "string"
    }


    columns {
      name = "actor2_type3_code"
      type = "string"
    }


    columns {
      name = "is_root_event"
      type = "boolean"
    }


    columns {
      name = "event_code"
      type = "string"
    }


    columns {
      name = "event_base_code"
      type = "string"
    }


    columns {
      name = "event_root_code"
      type = "string"
    }


    columns {
      name = "quad_class"
      type = "int"
    }


    columns {
      name = "goldstein_scale"
      type = "float"
    }


    columns {
      name = "num_mentions"
      type = "int"
    }


    columns {
      name = "num_sources"
      type = "int"
    }


    columns {
      name = "num_articles"
      type = "int"
    }


    columns {
      name = "avg_tone"
      type = "float"
    }


    columns {
      name = "actor1_geo_type"
      type = "int"
    }


    columns {
      name = "actor1_geo_full_name"
      type = "string"
    }


    columns {
      name = "actor1_geo_country_code"
      type = "string"
    }


    columns {
      name = "actor1_geo_adm1_code"
      type = "string"
    }


    columns {
      name = "actor1_geo_lat"
      type = "float"
    }


    columns {
      name = "actor1_geo_long"
      type = "string"
    }


    columns {
      name = "actor1_geo_feature_id"
      type = "int"
    }

    columns {
      name = "actor2_geo_type"
      type = "int"
    }


    columns {
      name = "actor2_geo_full_name"
      type = "string"
    }


    columns {
      name = "actor2_geo_country_code"
      type = "string"
    }


    columns {
      name = "actor2_geo_adm1_code"
      type = "string"
    }


    columns {
      name = "actor2_geo_lat"
      type = "float"
    }


    columns {
      name = "actor2_geo_long"
      type = "string"
    }


    columns {
      name = "actor2_geo_feature_id"
      type = "int"
    }


    columns {
      name = "action_geo_type"
      type = "int"
    }


    columns {
      name = "action_geo_full_name"
      type = "string"
    }


    columns {
      name = "action_geo_country_code"
      type = "string"
    }


    columns {
      name = "action_geo_adm1_code"
      type = "string"
    }


    columns {
      name = "action_geo_lat"
      type = "float"
    }


    columns {
      name = "action_geo_long"
      type = "string"
    }

    columns {
      name = "action_geo_feature_id"
      type = "int"
    }

    columns {
      name = "date_added"
      type = "int"
    }

    columns {
      name = "source_url"
      type = "string"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}

