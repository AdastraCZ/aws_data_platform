module "tables" {
  source                     = "./tables/terraform"
  curated_data_lake_bucket   = var.curated_data_lake_bucket
  curated_data_lake_database = var.curated_data_lake_database
}

module "crawlers" {
  source                     = "./crawlers/terraform"
  raw_data_lake_bucket       = var.raw_data_lake_bucket
  curated_data_lake_bucket   = var.curated_data_lake_bucket
  raw_data_lake_database     = var.raw_data_lake_database
  curated_data_lake_database = var.curated_data_lake_database
  crawler_role_arn           = data.aws_iam_role.glue_role.arn
}

module "jobs" {
  source           = "./glue_jobs/terraform"
  glue_jobs_bucket = var.glue_jobs_bucket
  glue_temp_bucket = var.glue_temp_bucket
  job_role_arn     = data.aws_iam_role.glue_role.arn
}
