resource "aws_security_group" "lab-alb" {
  name    = "terraform-labs-load-balancer"
  vpc_id  = aws_vpc.lab.id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Labs-Load-Balancer"
  }
}

resource "aws_lb" "lab" {
  name               = "terraform-labs-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lab-alb.id]
  subnets            = [aws_subnet.lab-public-1.id, aws_subnet.lab-public-2.id]

  tags = {
    Name = "Terraform-Labs-Load-Balancer"
  }
}

resource "aws_lb_target_group" "lab" {
  name     = "terraform-labs-lb-target-group"
  vpc_id   = aws_vpc.lab.id
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

  tags = {
    Name = "Terraform-Labs-Load-Balancer"
  }
}
