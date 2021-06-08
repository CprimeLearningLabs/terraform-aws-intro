data "aws_kms_key" "lab" {
  key_id = "alias/tflabs-dbkey"
}

resource "aws_security_group" "lab-database" {
  name    = "terraform-labs-database"
  vpc_id  = aws_vpc.lab.id

  ingress {
    description = "DB Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.lab-bastion.private_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Labs-Database"
  }
}

resource "aws_db_subnet_group" "lab-database" {
  name        = "terraform-labs-database"
  subnet_ids  = [aws_subnet.lab-private-1.id, aws_subnet.lab-private-2.id]

  tags = {
    Name = "Terraform-Labs-Database"
  }
}

resource "aws_db_instance" "lab-database" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  storage_encrypted    = true
  kms_key_id           = data.aws_kms_key.lab.arn
  multi_az             = false
  identifier           = "terraform-labs-database"
  name                 = "appdb"
  username             = "dbadmin"
  password             = "Awstfl4b$"
  skip_final_snapshot  = true

  vpc_security_group_ids  = [aws_security_group.lab-database.id]
  db_subnet_group_name    = aws_db_subnet_group.lab-database.id

  tags = {
    Name = "Terraform-Labs-Database"
  }
}
