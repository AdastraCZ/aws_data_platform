variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "raw_data_lake_bucket" {
  type    = string
  default = "s3://adastracz-demo-datalake-raw"
}

variable "curated_data_lake_bucket" {
  type    = string
  default = "s3://adastracz-demo-datalake-curated"
}

variable "raw_data_lake_database" {
  type    = string
  default = "data_lake_raw"
}

variable "curated_data_lake_database" {
  type    = string
  default = "data_lake_curated"
}

variable "glue_jobs_bucket" {
  type    = string
  default = "adastracz-demo-glue-jobs"
}

variable "glue_temp_bucket" {
  type    = string
  default = "adastracz-demo-glue-temp"
}
