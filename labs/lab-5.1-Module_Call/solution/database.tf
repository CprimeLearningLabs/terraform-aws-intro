data "aws_kms_key" "lab" {
  key_id = "alias/tflabs-dbkey"
}

resource "random_password" "dbpassword" {
  length           = 12
  min_numeric      = 1
  special          = true
  override_special = "_%#*!"
}

resource "aws_ssm_parameter" "dbpassword" {
  name  = "/database/${local.environment}/password"
  type  = "SecureString"
  value = random_password.dbpassword.result
  tags = {
    Name = "Terraform-Labs-Database"
  }
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
  name                 = var.db_name
  username             = "dbadmin"
  password             = aws_ssm_parameter.dbpassword.value
  skip_final_snapshot  = true

  vpc_security_group_ids  = [aws_security_group.lab-database.id]
  db_subnet_group_name    = aws_db_subnet_group.lab-database.id

  tags = {
    Name = "Terraform-Labs-Database"
  }
}

module "dynamodb" "lab" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "1.0.0"

  name     = "terraform-labs-kvstore"
  hash_key = "Property"

  attributes = [
    {
      name = "Property"
      type = "S"
    }
  ]
}
