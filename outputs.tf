output "primary_instance_ip" {
  description = "IP address of primary instance"
  value = aws_instance.primary_instance.public_ip
}

output "secondary_instance_ip" {
  description = "IP address of secondary instance"
  value = aws_instance.secondary_instance
}