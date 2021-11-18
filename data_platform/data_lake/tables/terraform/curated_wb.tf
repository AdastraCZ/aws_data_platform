resource "aws_glue_catalog_table" "wb_gdp_per_capita" {
  name          = "wb_gdp_per_capita"
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
    location      = "${var.curated_data_lake_bucket}/wb_gdp_per_capita/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "wb_gdp_per_capita"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "country_iso_3_code"
      type = "string"
    }

    columns {
      name = "val"
      type = "double"
    }

    columns {
      name = "valid_from_date_cet"
      type = "date"
    }

    columns {
      name = "valid_to_date_cet"
      type = "date"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}

/* co2 emissions */
resource "aws_glue_catalog_table" "wb_co2_emissions" {
  name          = "wb_co2_emissions"
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
    location      = "${var.curated_data_lake_bucket}/wb_co2_emissions/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "wb_co2_emissions"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "country_iso_3_code"
      type = "string"
    }

    columns {
      name = "val"
      type = "double"
    }

    columns {
      name = "valid_from_date_cet"
      type = "date"
    }

    columns {
      name = "valid_to_date_cet"
      type = "date"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}



/* income_share_10 */
resource "aws_glue_catalog_table" "wb_income_share_10" {
  name          = "wb_income_share_10"
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
    location      = "${var.curated_data_lake_bucket}/wb_income_share_10/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "wb_income_share_10"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "country_iso_3_code"
      type = "string"
    }

    columns {
      name = "val"
      type = "double"
    }

    columns {
      name = "valid_from_date_cet"
      type = "date"
    }

    columns {
      name = "valid_to_date_cet"
      type = "date"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}

/* population_growth */
resource "aws_glue_catalog_table" "wb_population_growth" {
  name          = "wb_population_growth"
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
    location      = "${var.curated_data_lake_bucket}/wb_population_growth/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "wb_population_growth"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "country_iso_3_code"
      type = "string"
    }

    columns {
      name = "val"
      type = "double"
    }

    columns {
      name = "valid_from_date_cet"
      type = "date"
    }

    columns {
      name = "valid_to_date_cet"
      type = "date"
    }

    columns {
      name = "create_datetime_cet"
      type = "timestamp"
    }

  }
}


/* country details */
resource "aws_glue_catalog_table" "lov_wb_countries" {
  name          = "lov_wb_countries"
  database_name = var.curated_data_lake_database
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "${var.curated_data_lake_bucket}/lov_wb_countries/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "lov_wb_countries"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "country_iso_3_code"
      type = "string"
    }

    columns {
      name = "country_iso_2_code"
      type = "string"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "region_name"
      type = "string"
    }

    columns {
      name = "region_iso_2_code"
      type = "string"
    }

    columns {
      name = "admin_region_name"
      type = "string"
    }

    columns {
      name = "admin_region_iso_2_code"
      type = "string"
    }

    columns {
      name = "income_level"
      type = "string"
    }

    columns {
      name = "income_level_iso_2_code"
      type = "string"
    }

    columns {
      name = "lending_type"
      type = "string"
    }

    columns {
      name = "lending_type_iso_2_code"
      type = "string"
    }

    columns {
      name = "capital_city"
      type = "string"
    }

    columns {
      name = "long"
      type = "double"
    }

    columns {
      name = "lat"
      type = "double"
    }

    columns {
      name = "create_datetime_utc"
      type = "timestamp"
    }

  }
}
