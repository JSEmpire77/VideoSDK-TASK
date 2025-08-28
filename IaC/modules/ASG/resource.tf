resource "aws_autoscaling_group" "worker_asg" {
  name                = "TASK-ASG"
  vpc_zone_identifier = [var.subnet_ids]
  launch_template {
    id      = var.launch_template
    version = "$Latest"
  }
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = var.target_group_arns
}

# Scale Up Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "TASK-ASG-scale-up"
  autoscaling_group_name = aws_autoscaling_group.worker_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

# Scale Down Policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "TASK-ASG-scale-down"
  autoscaling_group_name = aws_autoscaling_group.worker_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}
