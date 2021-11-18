# I am using capacity = 2 almost everywhere. The datasets we are working with are really small, no need for Spark super power. 


resource "aws_glue_job" "cur_wb_gdp_per_capita" {
  name     = "curated_wb_gdp_per_capita"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_wb_gdp_per_capita.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "cur_wb_income_share_10" {
  name     = "curated_wb_income_share_10"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_wb_income_share_10.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}


resource "aws_glue_job" "cur_wb_population_growth" {
  name     = "curated_wb_population_growth"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_wb_population_growth.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "cur_wb_co2_emissions" {
  name     = "curated_wb_co2_emissions"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_wb_co2_emissions.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}


resource "aws_glue_job" "cur_lov_wb_countries" {
  name     = "curated_lov_wb_countries"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_lov_wb_countries.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "cur_gdelt_events_bkp" {
  name     = "curated_gdelt_events_bkp"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_gdelt_events.py"
  }
  # be careful. This dataset is huuge. You need to use lot of DPUs (its quite pricey)
  #max_capacity = 250
  glue_version = "3.0"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--TempDir"                          = "s3://${var.glue_temp_bucket}/curated/gdelt_events_bkp/"
  }
}


resource "aws_glue_job" "cur_gdelt_events" {
  name     = "curated_gdelt_events"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_gdelt_events.py"
  }
  # be careful. This dataset is huuge. You need to use lot of DPUs (its quite pricey)
  #max_capacity = 250
  glue_version = "3.0"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--TempDir"                          = "s3://${var.glue_temp_bucket}/curated/gdelt_events/"
  }
}

resource "aws_glue_job" "cur_gdelt_event_type" {
  name     = "curated_gdelt_event_type"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_gdelt_event_type.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "cur_gdelt_actor_type" {
  name     = "curated_gdelt_actor_type"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_gdelt_actor_type.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}


resource "aws_glue_job" "cur_gdelt_country_type" {
  name     = "curated_gdelt_country_type"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/curated/cur_gdelt_country_type.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

