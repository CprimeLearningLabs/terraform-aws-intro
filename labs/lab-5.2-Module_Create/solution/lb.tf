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

module "load-balancer" {
  source = "./load-balancer"

  vpc_id          = aws_vpc.lab.id
  subnets         = [aws_subnet.lab-public-1.id, aws_subnet.lab-public-2.id]
  security_groups = [aws_security_group.lab-alb.id]
}
