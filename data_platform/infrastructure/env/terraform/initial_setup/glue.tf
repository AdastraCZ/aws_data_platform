resource "aws_s3_bucket" "adastracz-demo-glue-job" {
  bucket = "adastracz-demo-glue-jobs"
  acl    = "private"
  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket" "adastracz-demo-glue-temp" {
  bucket = "adastracz-demo-glue-temp"
  acl    = "private"
  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket" "adastracz-demo-datalake-raw" {
  bucket = "adastracz-demo-datalake-raw"
  acl    = "private"
  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket" "adastracz-demo-datalake-curated" {
  bucket = "adastracz-demo-datalake-curated"
  acl    = "private"
  versioning {
    enabled = false
  }
}

# Glue Databases
resource "aws_glue_catalog_database" "data_lake_raw" {
  name = "data_lake_raw"
}

resource "aws_glue_catalog_database" "data_lake_curated" {
  name = "data_lake_curated"
}

