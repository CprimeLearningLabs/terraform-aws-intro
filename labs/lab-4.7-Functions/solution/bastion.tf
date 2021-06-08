locals {
  bastion_ingress = {
    "SSH Access" = {
      port     = 22
      protocol = "tcp"
      cidrs    = ["0.0.0.0/0"]
    }
    "VPN Access" = {
      port     = 1194
      protocol = "tcp"
      cidrs    = ["10.1.8.0/24"]
    }
  }
}

resource "aws_security_group" "lab-bastion" {
  name    = "terraform-labs-bastion"
  vpc_id  = aws_vpc.lab.id

  dynamic "ingress" {
    for_each = local.bastion_ingress
    content {
      description = ingress.key
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Labs-Bastion"
  }
}

resource "aws_instance" "lab-bastion" {
  ami                    = local.instance_ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.lab-public-1.id
  vpc_security_group_ids = [aws_security_group.lab-bastion.id]
  key_name               = var.vm_keypair_name

  tags = {
    Name = "Terraform-Labs-Bastion"
  }
}
