variable "region" {
  default = "ap-south-1" #Mumbai 
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "subnet_availability_zone" {
  default = "ap-south-1a"
}