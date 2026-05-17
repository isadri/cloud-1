resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_block

  # Enable auto-assign public ip address
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

resource "aws_route_table" "subnet_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-gw-rt"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-gw"
  }
}

resource "aws_route_table_association" "associate_with_subnet" {
  route_table_id = aws_route_table.subnet_route_table.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_network_acl" "app_network_acl" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-nacl"
  }
}

resource "aws_network_acl_association" "associate_with_subnet" {
  network_acl_id = aws_network_acl.app_network_acl.id
  subnet_id      = aws_subnet.public.id
}

moved {
  from = aws_vpc.vpc
  to   = aws_vpc.main
}