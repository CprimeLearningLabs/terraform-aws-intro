# Database and Data Source

Lab Objective:
- Use a data source to obtain a KMS key
- Add a database to your infrastructure

## Preparation

If you did not complete lab 3.2, you can simply copy the solution code from that lab (and run terraform apply) as the starting point for this lab.

## Lab

### Add a Data Source

To provide security of data at rest in our infrastructure, we will be creating a database that is encrypted.  For this, we will need an encryption key.  Let's suppose that in our organization the management of keys is handled by a separate security group that has already created encryption keys in AWS KMS.

In order to read a key from KMS, we will need to use a data source in Terraform.

Create a new file `database.tf`.
```
touch database.tf
```

Open the file for edit and add a data source to read a specified key from AWS KMS.  The "key_id" provides the criteria by which to find the desired key.
```
data "aws_kms_key" "lab" {
  key_id = "alias/tflabs-dbkey"
}
```

### Define a Database

Continue to edit the `database.tf` file.  We will be adding a few new resources to instantiate a MySQL database.

1. A security group to enable access to the database from the bastion host.
```
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
```

2. A database subnet group to specify the private subnets on which the database is to be created.  AWS requires at least two subnets in a subnet group.
```
resource "aws_db_subnet_group" "lab-database" {
  name        = "terraform-labs-database"
  subnet_ids  = [aws_subnet.lab-private-1.id, aws_subnet.lab-private-2.id]

  tags = {
    Name = "Terraform-Labs-Database"
  }
}
```

3. A MySQL database. Notice that the data source is referenced for the kms key.
```
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
```

Look through the resources for a moment. What is the processing order dependency between the resources?

Run terraform validate to make sure you have no errors:
```
terraform validate
```

Run terraform plan and verify that three new resources will be created.  The data source is read by Terraform during the plan generation in order to populate the ARN value for the "kms_key_id" attribute of the aws_db_instance resource.
```
terraform plan
```

Run terraform apply. (Remember to agree to the changes.)  The database can sometimes take several minutes to create.
```
terraform apply
```
