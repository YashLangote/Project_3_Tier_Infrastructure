variable "server_name" {
  description = "Name prefix for the EC2 instances (e.g., web-server or app-server)"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance (e.g., t2.micro)"
  type        = string
  default     = "t3.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs where instances will be launched"
  type        = list(string)
}

variable "security_group_id" {
  description = "The Security Group ID to attach to the instances"
  type        = string
}

variable "user_data_script" {
  description = "The startup script to run on the instances"
  type        = string
  default     = ""
}