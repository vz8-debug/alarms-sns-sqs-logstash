variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
  default     = "prod"
}

variable "queue_name" {
  type        = string
  description = "Name of the SQS queue"
  default     = "cloudwatch-alarms-queue"
}

variable "topic_name" {
  type        = string
  description = "Name of the SNS topic"
  default     = "cloudwatch-alarms-topic"
}

variable "create_example_alarm" {
  type        = bool
  description = "Whether to create the example EC2 CPU alarm within the module"
  default     = true
}

variable "target_instance_id" {
  type        = string
  description = "EC2 Instance ID for the example alarm (Required if create_example_alarm is true)"
  default     = "i-1234567890abcdef0"
}

