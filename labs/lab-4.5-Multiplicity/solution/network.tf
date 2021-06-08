resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id
}

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

resource "aws_route_table_association" "lab-public-1" {
  subnet_id      = aws_subnet.lab-public-1.id
  route_table_id = aws_route_table.lab-public.id
}

resource "aws_route_table_association" "lab-public-2" {
  subnet_id      = aws_subnet.lab-public-2.id
  route_table_id = aws_route_table.lab-public.id
}

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
