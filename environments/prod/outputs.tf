output "web_server_public_ips" {
  description = "Public IPs of the Web Servers to access the HTML form"
  value       = module.web_tier.public_ips
}

output "database_endpoint" {
  description = "The RDS connection endpoint"
  value       = module.database_tier.db_endpoint
}