output "instance_ids" {
  description = "The IDs of the created EC2 instances"
  value       = aws_instance.server[*].id
}

output "public_ips" {
  description = "The public IP addresses of the instances (if applicable)"
  value       = aws_instance.server[*].public_ip
}

output "private_ips" {
  description = "The private IP addresses of the instances"
  value       = aws_instance.server[*].private_ip
}