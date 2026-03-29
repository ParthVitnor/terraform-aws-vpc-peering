resource "aws_vpc" "primary_vpc" {
  cidr_block = var.primary_vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "primary-vpc"
  }
}

resource "aws_subnet" "primary_subnet" {
  vpc_id = aws_vpc.primary_vpc.id
  cidr_block = var.primary_subnet_cidr_block
  availability_zone = var.subnet_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name ="primary-subnet"
  }
}

resource "aws_internet_gateway" "primary_vpc_igw" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "primary-vpc-igw"
  }
}

resource "aws_route_table" "primary_vpc_rt" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "primary-rt"
  }
}

resource "aws_route" "route_to_igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.primary_vpc_igw.id
  route_table_id = aws_route_table.primary_vpc_rt.id
}


resource "aws_route_table_association" "primary_vpc_internet_assoc" {
  subnet_id = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_vpc_rt.id
}

resource "aws_vpc" "secondary_vpc" {
  cidr_block = var.secondary_vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "secondary-vpc"
  }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id = aws_vpc.secondary_vpc.id
  cidr_block = var.secondary_subnet_cidr_block
  availability_zone = var.subnet_availability_zone

  tags =  {
    Name = "secondary-subnet"
  }
}


resource "aws_internet_gateway" "secondary-vpc-igw" {
  vpc_id = aws_vpc.secondary_vpc.id

  tags = {
    Name = "secondary-vpc-igw"
  }
}

resource "aws_route_table" "secondary_vpc_rt" {
  vpc_id = aws_vpc.secondary_vpc.id

  tags = {
    Name ="secondary-rt"
  }
}

resource "aws_route" "secondary_rote" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.secondary-vpc-igw.id
  route_table_id = aws_route_table.secondary_vpc_rt.id
}

resource "aws_route_table_association" "primary_vpc_internet_assoc" {
  subnet_id = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_vpc_rt.id
}



resource "tls_private_key" "ssh_key" {
  algorithm = var.ssh_key_algorithm
  rsa_bits = var.ssh_key_bits
}

resource "local_file" "ec2_private_key" {
  filename = "${path.module}/ec2-key.pem"
  content = tls_private_key.ssh_key.private_key_pem
  file_permission = "0400"

}

resource "aws_key_pair" "ec2_key_pair" {
  key_name = var.key_pair_name
  public_key = tls_private_key.ssh_key.public_key_openssh

}