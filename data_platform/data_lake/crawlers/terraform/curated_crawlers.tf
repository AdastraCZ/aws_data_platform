# Crawlers
resource "aws_glue_crawler" "wb_gdp_per_capita_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_wb_gdp_per_capita"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/wb_gdp_per_capita/"
  }
}

resource "aws_glue_crawler" "wb_income_share_10_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_wb_income_share_10"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/wb_income_share_10/"
  }
}

resource "aws_glue_crawler" "wb_population_growth_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_wb_population_growth"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/wb_population_growth/"
  }
}

resource "aws_glue_crawler" "wb_co2_emissions_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_wb_co2_emissions"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/wb_co2_emissions/"
  }
}

resource "aws_glue_crawler" "lov_wb_countries_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_lov_wb_countries"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/lov_wb_countries/"
  }
}

resource "aws_glue_crawler" "gdelt_events_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_gdelt_events"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/gdelt_events/"
  }
}


resource "aws_glue_crawler" "gdelt_events_sql_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_gdelt_events_sql"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/gdelt_events_sql/"
  }
}

resource "aws_glue_crawler" "gdelt_event_type_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_gdelt_event_type"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/gdelt_event_type/"
  }
}

resource "aws_glue_crawler" "gdelt_actor_type_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_gdelt_actor_type"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/gdelt_actor_type/"
  }
}

resource "aws_glue_crawler" "gdelt_country_type_curated" {
  database_name = var.curated_data_lake_database
  name          = "curated_gdelt_country_type"
  role          = var.crawler_role_arn
  s3_target {
    path = "${var.curated_data_lake_bucket}/gdelt_country_type/"
  }
}
