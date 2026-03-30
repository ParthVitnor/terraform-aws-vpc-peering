variable "region" {
  default = "ap-south-1" #Mumbai 
}

variable "primary_vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "primary_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "subnet_availability_zone" {
  default = "ap-south-1a"
}


variable "secondary_vpc_cidr_block" {
  default = "11.0.0.0/16"
}

variable "secondary_subnet_cidr_block" {
  default = "11.0.1.0/24"
}

variable "ssh_key_algorithm" {
  default = "RSA"
}

variable "ssh_key_bits" {
  default = 4096
}

variable "key_pair_name" {
  default = "instance-key-pair"
}

variable "instance_type" {
  default = "t3.micro" #free tier 
}

variable "root_block_volume_size" {
  default = 5
}

variable "root_block_volume_type" {
  default = "gp3"
}

variable "root_dlt_on_termination" {
  default = true
}