resource "aws_sqs_queue" "rds_ingest" {
  name                      = "rds_ingest"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.rds_ingest_dlq.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "rds_ingest_dlq" {
  name                      = "rds_ingest_dlq"
}