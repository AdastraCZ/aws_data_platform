# classifier
resource "aws_glue_classifier" "CustomJsonClassifier" {
  name = "CustomJsonClassifier"

  json_classifier {
    json_path = "$[*]"
  }
}

# Crawlers
resource "aws_glue_crawler" "gdp_per_capita_raw" {
  database_name = var.raw_data_lake_database
  name          = "raw_gdp_per_capita"
  role          = var.crawler_role_arn
  classifiers   = [aws_glue_classifier.CustomJsonClassifier.name]
  s3_target {
    path = "${var.raw_data_lake_bucket}/world_bank/gdp_per_capita/"
  }
}

resource "aws_glue_crawler" "income_share_10_raw" {
  database_name = var.raw_data_lake_database
  name          = "raw_income_share_10"
  role          = var.crawler_role_arn
  classifiers   = [aws_glue_classifier.CustomJsonClassifier.name]
  s3_target {
    path = "${var.raw_data_lake_bucket}/world_bank/income_share_10/"
  }
}

resource "aws_glue_crawler" "population_growth_raw" {
  database_name = var.raw_data_lake_database
  name          = "raw_population_growth"
  role          = var.crawler_role_arn
  classifiers   = [aws_glue_classifier.CustomJsonClassifier.name]
  s3_target {
    path = "${var.raw_data_lake_bucket}/world_bank/population_growth/"
  }
}

resource "aws_glue_crawler" "co2_emissions_raw" {
  database_name = var.raw_data_lake_database
  name          = "raw_co2_emissions"
  role          = var.crawler_role_arn
  classifiers   = [aws_glue_classifier.CustomJsonClassifier.name]
  s3_target {
    path = "${var.raw_data_lake_bucket}/world_bank/co2_emissions/"
  }
}

resource "aws_glue_crawler" "lov_countries_raw" {
  database_name = var.raw_data_lake_database
  name          = "raw_lov_countries"
  role          = var.crawler_role_arn
  classifiers   = [aws_glue_classifier.CustomJsonClassifier.name]
  s3_target {
    path = "${var.raw_data_lake_bucket}/world_bank/lov_countries/"
  }
}
