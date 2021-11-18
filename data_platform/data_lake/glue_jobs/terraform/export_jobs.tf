# I am using capacity = 2 almost everywhere. The datasets we are working with are really small, no need for Spark super power. 
# we need to have aurora connection defined. These jobs connect to Aurora using JDBC

resource "aws_glue_job" "export_wb_gdp_per_capita" {
  name     = "export_wb_gdp_per_capita"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/export/exp_wb_gdp_per_capita.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  connections  = ["aurora"]
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "export_wb_income_share_10" {
  name     = "export_wb_income_share_10"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/export/exp_wb_income_share_10.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  connections  = ["aurora"]
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "export_wb_population_growth" {
  name     = "export_wb_population_growth"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/export/exp_wb_population_growth.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  connections  = ["aurora"]
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "export_wb_co2_emissions" {
  name     = "export_wb_co2_emissions"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/export/exp_wb_co2_emissions.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  connections  = ["aurora"]
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_job" "expport_lov_wb_countries" {
  name     = "export_lov_wb_countries"
  role_arn = var.job_role_arn
  command {
    script_location = "s3://${var.glue_jobs_bucket}/export/exp_lov_wb_countries.py"
  }
  glue_version = "3.0"
  max_capacity = "2"
  connections  = ["aurora"]
  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}
