resource "aws_eip" "lab" {
  tags = {
    Name = "Terraform-Labs"
  }
}

resource "aws_nat_gateway" "lab" {
  allocation_id = aws_eip.lab.id
  subnet_id     = aws_subnet.lab-public-1.id
}

resource "aws_route_table" "lab-private" {
  vpc_id = aws_vpc.lab.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lab.id
  }
  tags = {
    Name = "Terraform-Labs-Private"
  }
}

resource "aws_route_table_association" "lab-private-1" {
  subnet_id      = aws_subnet.lab-private-1.id
  route_table_id = aws_route_table.lab-private.id
}

resource "aws_route_table_association" "lab-private-2" {
  subnet_id      = aws_subnet.lab-private-2.id
  route_table_id = aws_route_table.lab-private.id
}
