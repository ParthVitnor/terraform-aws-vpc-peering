resource "aws_vpc" "public_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "public-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.public_vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.subnet_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name ="public-subnet"
  }
}

resource "aws_internet_gateway" "public_vpc-igw" {
  vpc_id = aws_vpc.public_vpc.id

  tags = {
    Name = "public-vpc-igw"
  }
}

resource "aws_route_table" "public_vpc_rt" {
  vpc_id = aws_vpc.public_vpc.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "public_vpc_igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_public_vpc.id
  route_table_id = aws_route_table.public_vpc_rt.id
}


resource "aws_route_table_association" "igw_internet_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_vpc_rt.id
}

resource "aws_vpc" "private_vpc" {
  cidr_block = "11.0.0.0/0"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "private-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.private_vpc.id
  cidr_block = "11.0.1.0/0"
  availability_zone = var.subnet_availability_zone

  tags =  {
    Name = "private-subnet"
  }
}


resource "aws_internet_gateway" "private-vpc-igw" {
  vpc_id = aws_vpc.private_vpc.id

  tags = {
    Name = "private-vpc-igw"
  }
}

resource "aws_route_table" "private_vpc_rt" {
  vpc_id = aws_vpc.private_vpc.id

  tags = {
    Name ="private-rt"
  }
}

resource "aws_route" "private_rote" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.private-vpc-igw.id
  route_table_id = aws_route_table.private_vpc_rt.id
}

resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_vpc_rt.id
}