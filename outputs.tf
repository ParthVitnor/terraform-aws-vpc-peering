output "primary_instance_ip" {
  description = "IP address of primary instance"
  value = aws_instance.primary_instance.public_ip
}

output "secondary_instance_ip" {
  description = "IP address of secondary instance"
  value = aws_instance.secondary_instance
}

output "vpc_peering_status" {
  description = "Status of the VPC peering "
  value = aws_vpc_peering_connection.primary_to_secondary.status
}