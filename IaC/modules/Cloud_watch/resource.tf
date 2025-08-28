# SNS Topic for notifications
resource "aws_sns_topic" "asg_notifications" {
  name = "TASK-asg-topic"
}

# SNS Subscription (Email)
resource "aws_sns_topic_subscription" "email_notification" {
  topic_arn = aws_sns_topic.asg_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email 
}

# CloudWatch Alarm for High CPU (Scale Up)
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "TASK-High-CPU-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "CPU utilization > 70%, triggering scale-up"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  alarm_actions = [
    var.scale_up_policy_arn,
    aws_sns_topic.asg_notifications.arn 
  ]
}

# CloudWatch Alarm for Low CPU (Scale Down)
resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "TASK-Low-CPU-Alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "CPU utilization < 30%, triggering scale-down"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  alarm_actions = [
    var.scale_down_policy_arn,
    aws_sns_topic.asg_notifications.arn # <<< Notifying SNS when alarm triggers
  ]
}
