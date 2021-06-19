terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = "~> 0.15.0"
}

resource "aws_lb" "lab" {
  name               = "terraform-labs-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  tags = {
    Name = "Terraform-Labs-Load-Balancer"
  }
}

resource "aws_lb_target_group" "lab" {
  name     = "terraform-labs-lb-target-group"
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"

  tags = {
    Name = "Terraform-Labs-Load-Balancer"
  }
}

resource "aws_lb_listener" "lab" {
  load_balancer_arn = aws_lb.lab.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lab.id
    type             = "forward"
  }
}
