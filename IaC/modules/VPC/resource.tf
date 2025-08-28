resource "aws_vpc" "terra_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.public_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.public_subnet_name}"
  }
}

resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id
}

resource "aws_route_table" "terra_rt" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags = {
    Name = var.public_subnet_route_name
  }
}

resource "aws_route_table_association" "ass_to_sub" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.terra_rt.id
}

resource "aws_subnet" "private_sub" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.private_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.private_subnet_name}"
  }
}

resource "aws_eip" "terra_nat_eip" {
  domain = "vpc"
  tags = {
    Name = "TASK-NAT-EIP"
  }
}

resource "aws_nat_gateway" "terra_nat" {
  allocation_id = aws_eip.terra_nat_eip.id
  subnet_id     = aws_subnet.public_sub.id
  tags = {
    Name = "TASK-NAT-Gateway"
  }
}

resource "aws_route_table" "private_terra_rt" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terra_nat.id
  }
  tags = {
    Name = var.private_subnet_route_name
  }
}

resource "aws_route_table_association" "ass_to_p_sub" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private_terra_rt.id
}