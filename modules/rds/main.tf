# DB Subnet Group (tells RDS which private subnets to use)
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

# The RDS Database Instance
resource "aws_db_instance" "mysql" {
  identifier             = "ecommerce-db-instance"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_class
  allocated_storage      = 20
  storage_type           = "gp2"
  
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  
  # Ensure the database is not publicly accessible
  publicly_accessible    = false
  
  # Skip final snapshot for this project to make destroying the environment faster
  skip_final_snapshot    = true 
}