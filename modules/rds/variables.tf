variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "ecommerce_db"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true # This prevents Terraform from printing the password in the console logs
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}