# Create a Network

Lab Objective:
- Create a simple network in AWS

## Lab

### Change to use AWS Provider

Open "main.tf" for edit and make the following changes:

1. Add AWS as a required provider.  We continue to use AWS for storing backend state.  The terraform block in "main.tf" should look as follows:

```
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    region         = "us-west-2"
    key            = "terraform.labs.tfstate"
    dynamodb_table = "terraform-state-lock"
  }
  required_version = "~> 0.15.0"
}
```

2. Add a provider block to configure the AWS provider.  The configuration specifies the AWS region into which we will create our infrastructure, as well as declares some common tags to associate to all created resources.

```
provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Name = "Terraform-Labs"
      Environment = "Lab"
    }
  }
}
```

3. Delete the "random_number" resource from the file.  We no longer need that resource.


### Define Network Resources

Create a new file “network.tf”.
```
touch network.tf
```

Either copy the contents of network.tf from the solution folder for the lab, or copy the code snippets in the following descriptions.

We will be defining a number of new resources in this file.  Let's walk through them.

1. A Virtual Private Cloud (VPC) for our network.

```
resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"
}
```

2. An internet gateway to enable traffic to and from the public internet.  

```
resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id
}
```

3. Two public subnets.  Notice that the subnet CIDR blocks are within the VPC CIDR range.

```
resource "aws_subnet" "lab-public-1" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Terraform-Labs-Public-1"
    SubnetTier = "Public"
  }
}

resource "aws_subnet" "lab-public-2" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Terraform-Labs-Public-2"
    SubnetTier = "Public"
  }
}
```

3. A route table to direct outbound Internet traffic to the internet gateway.

```
resource "aws_route_table" "lab-public" {
  vpc_id = aws_vpc.lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }
  tags = {
    Name = "Terraform-Labs-Public"
  }
}
```

4. An association of the route table to each of the public subnets.

```
resource "aws_route_table_association" "lab-public-1" {
  subnet_id      = aws_subnet.lab-public-1.id
  route_table_id = aws_route_table.lab-public.id
}

resource "aws_route_table_association" "lab-public-2" {
  subnet_id      = aws_subnet.lab-public-2.id
  route_table_id = aws_route_table.lab-public.id
}
```

5. Two private subnets.

```
resource "aws_subnet" "lab-private-1" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.0.16.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Terraform-Labs-Private-1"
    SubnetTier = "Application"
  }
}

resource "aws_subnet" "lab-private-2" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.0.17.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "Terraform-Labs-Private-2"
    SubnetTier = "Application"
  }
}
```

Run terraform init.  Do you know why we need to re-run this command?
```
terraform init
```
Run terraform validate.
```
terraform validate
```
Run terraform plan.
```
terraform plan
```
(If you see in the plan that random_integer.number is to be destroyed, that is okay.  Do you know why this is happening?)

![Random integer destroy warning](./images/tf-plan.png "Random integer destroy warning")
<br /><br />

Run terraform apply to create all the new infrastructure.
```
terraform apply
```

### Viewing Results in the AWS Console

Let's use the AWS Console to see what we just created.  Minimize the Cloud Shell console so you can see the AWS Console UI fully.

In the menu bar at the top of the AWS Console page, select "Services".  Select VPC from the drop-down.

You should see the following.

![Azure Resource Groups](./images/az-rg.png "Azure Resource Groups")
<br /><br />

Click on the "Terraform-Labs" VPC created by Terraform. (The other VPC is a default VPC. You can ignore it.)

Confirm you see the VPC and subnets created.<br />

![Resource Group containing virtual network and security group](./images/az-rg-vnet.png "Resource Group containing virtual network and security group")

<br /><br />
Click on the virtual network and confirm it has the expected subnets, and that the public subnet has the expected security group.

![Virtual network subnets and security group](./images/az-vnet-subnets.png "Virtual network subnets and security group")
