output "lb_dns_name" {
  value = aws_lb.terra_lb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.terra_target_group.arn
}

output "lb_sg_id" {
  value = aws_security_group.terra_sg_alb.id
}
