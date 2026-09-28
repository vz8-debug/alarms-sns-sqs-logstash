# --- Amazon SQS ---
resource "aws_sqs_queue" "this" {
  name                      = "${var.queue_name}-${var.environment}"
  message_retention_seconds = 86400

  tags = {
    Environment = var.environment
  }
}

resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSNSTopicToSendMessage"
        Effect    = "Allow"
        Principal = { Service = "://amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.this.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.this.arn
          }
        }
      }
    ]
  })
}

# --- Amazon SNS ---
resource "aws_sns_topic" "this" {
  name = "${var.topic_name}-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

# --- CloudWatch Metric Alarm (Optional Example) ---
resource "aws_cloudwatch_metric_alarm" "example" {
  count               = var.create_example_alarm ? 1 : 0
  alarm_name          = "high-cpu-utilization-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors EC2 instance high CPU utilization"

  alarm_actions             = [aws_sns_topic.this.arn]
  ok_actions                = [aws_sns_topic.this.arn]
  insufficient_data_actions = [aws_sns_topic.this.arn]

  dimensions = {
    InstanceId = var.target_instance_id
  }
}

