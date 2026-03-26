resource "aws_vpc" "public_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "public-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.public_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name ="public-subnet"
  }
}

resource "aws_internet_gateway" "igw_public_vpc" {
  vpc_id = aws_vpc.public_vpc.id

  tags = {
    Name = "igw-public-vpc"
  }
}

resource "aws_route_table" "public_vpc_rt" {
  vpc_id = aws_vpc.public_vpc.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "internet_access_igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_public_vpc.id
  route_table_id = aws_route_table.public_vpc_rt.id
}


resource "aws_route_table_association" "igw_internet_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_vpc_rt.id
}

