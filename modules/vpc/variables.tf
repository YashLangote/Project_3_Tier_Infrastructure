variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for Web Tier (Public)"
  type        = list(string)
}

variable "app_subnets" {
  description = "CIDR blocks for Application Tier (Private)"
  type        = list(string)
}

variable "db_subnets" {
  description = "CIDR blocks for Database Tier (Private)"
  type        = list(string)
}