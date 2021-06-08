resource "aws_security_group" "lab-bastion" {
  name    = "terraform-labs-bastion"
  vpc_id  = aws_vpc.lab.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "VPN Access"
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = ["10.1.8.0/24"]
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
  key_name               = "tf-lab-key"

  tags = {
    Name = "Terraform-Labs-Bastion"
  }
}
