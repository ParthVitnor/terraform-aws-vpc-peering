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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "primary_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.primary_subnet

  vpc_security_group_ids = [aws_security_group.primary_sg.id]

  key_name = aws_key_pair.ec2_key_pair.id
  root_block_device {
    volume_size = var.root_block_volume_size
    volume_type = var.root_block_volume_type
    delete_on_termination = var.root_dlt_on_termination
    encrypted = true
  }

tags = {
  Name = "primary-instance"
  }
}


resource "aws_instance" "secondary_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.secondary_subnet

  key_name = aws_key_pair.ec2_key_pair.id
  root_block_device {
    volume_size = var.root_block_volume_size
    volume_type = var.root_block_volume_type
    delete_on_termination = var.root_dlt_on_termination
    encrypted = true
  }

tags = {
  Name = "secondary-instance"
  }
}


resource "aws_security_group" "primary_sg" {
  name        = "primary_sg"
  description = "Allow TLS inbound traffic and all outbound traffic for primary instance"
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "primary_sg"
  }
}



resource "aws_security_group_rule" "allow_ssh_primary" {
  type = "ingress"
  security_group_id = aws_security_group.primary_sg.id
  from_port = 22
  protocol = "tcp"
  to_port = 22
  cidr_blocks = "0.0.0.0/0"  
}


resource "aws_security_group_rule" "allow_ICMP_primary" {
  type = "ingress"
  security_group_id = aws_security_group.primary_sg.id
  from_port = -1
  protocol = "icmp"
  to_port = -1
  cidr_blocks = var.secondary_vpc_cidr_block 
}


resource "aws_security_group_rule" "allow_all" {
  type = "ingress"
  security_group_id = aws_security_group.primary_sg.id
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = var.secondary_vpc_cidr_block
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type = "egress"
  security_group_id = aws_security_group.primary_sg.id
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = "0.0.0.0/0"
}