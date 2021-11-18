# S3 buckets
resource "aws_s3_bucket" "athena_bucket" {
  bucket = "adastracz-demo-athena"
  acl    = "private"
  versioning {
    enabled = false
  }
}

# Athena workgroup
resource "aws_athena_workgroup" "adastra_work_group" {
  name = "AdastraWorkGroup"
  configuration {
    enforce_workgroup_configuration    = false
    publish_cloudwatch_metrics_enabled = false

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_bucket.bucket}/output/"
    }
  }
}
