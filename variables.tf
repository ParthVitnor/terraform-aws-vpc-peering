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