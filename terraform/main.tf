provider "aws" {
  region = "us-east-1"
}

# Instantiate the pipeline module
module "logstash_alarm_pipeline" {
  source             = "./modules/cw_alerts_pipeline"
  environment        = "prod"
  queue_name         = "logstash-ingest-queue"
  topic_name         = "cloudwatch-alerts-central"
  target_instance_id = "i-0abcd1234ef56789x"
}

# Example of attaching an OUTSIDE alarm to the module's SNS topic
resource "aws_cloudwatch_metric_alarm" "database_memory_alarm" {
  alarm_name          = "rds-high-memory-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 1000000000 # 1GB in bytes

  # Pass the SNS topic output directly from the module
  alarm_actions = [module.logstash_alarm_pipeline.sns_topic_arn]
}

