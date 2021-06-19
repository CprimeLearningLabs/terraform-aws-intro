locals {
  private_subnet_ids = [aws_subnet.lab-private-1.id, aws_subnet.lab-private-2.id]
}

resource "aws_security_group" "lab-cluster" {
  name    = "terraform-labs-cluster"
  vpc_id  = aws_vpc.lab.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.lab-bastion.private_ip}/32"]
  }
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lab-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Labs-Cluster"
  }
}

resource "aws_instance" "lab-cluster" {
  count = local.cluster_size

  ami           = local.instance_ami
  instance_type = "t3.micro"
  subnet_id     = local.private_subnet_ids[count.index % length(local.private_subnet_ids)]

  vpc_security_group_ids = [aws_security_group.lab-cluster.id]
  key_name               = var.vm_keypair_name

  tags = {
    Name = "Terraform-Labs-Cluster-${count.index}"
  }
}

resource "aws_lb_target_group_attachment" "lab-cluster" {
  count = local.cluster_size

  target_group_arn = module.load-balancer.target_group_arn
  target_id        = aws_instance.lab-cluster[count.index].id
  port             = 80
}
