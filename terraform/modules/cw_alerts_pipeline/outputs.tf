output "sqs_queue_arn" {
  value       = aws_sqs_queue.this.arn
  description = "The ARN of the SQS queue Logstash needs to read from"
}

output "sqs_queue_url" {
  value       = aws_sqs_queue.this.id
  description = "The URL of the SQS queue"
}

output "sns_topic_arn" {
  value       = aws_sns_topic.this.arn
  description = "The ARN of the SNS topic to attach to other CloudWatch alarms"
}

