variable "notification_email" {
  description = "Email address for SNS notifications"
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "scale_up_policy_arn" {
  description = "ARN of the Scale Up policy"
  type        = string
}

variable "scale_down_policy_arn" {
  description = "ARN of the Scale Down policy"
  type        = string
}
