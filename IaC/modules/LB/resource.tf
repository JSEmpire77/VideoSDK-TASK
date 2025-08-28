resource "aws_security_group" "terra_sg_alb" {
  name        = "TASK-LB_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.port_module #   #good must watch
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# reference : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "terra_lb" {
  name               = "TASK-LB"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids # gives public subnet
  security_groups    = [aws_security_group.terra_sg_alb.id]
  tags = {
    Name = "TASK-LB"
  }
}
#referance : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "terra_target_group" {
  name        = "TASK-TG"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "TASK-TG"
  }
}
#referance : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "terra_listener" {
  load_balancer_arn = aws_lb.terra_lb.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terra_target_group.arn
  }
}