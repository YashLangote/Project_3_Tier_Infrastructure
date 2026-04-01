# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1" # Change this to your preferred region (e.g., ap-south-1)
}

# 1. Call the VPC Module
module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr       = "10.0.0.0/16"
  azs            = ["eu-north-1a", "eu-north-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  app_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  db_subnets     = ["10.0.5.0/24", "10.0.6.0/24"]
}

# 2. Security Groups (Defined in root for easy referencing)
resource "aws_security_group" "web_sg" {
  name        = "prod-web-sg"
  description = "Allow HTTP/HTTPS from internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "prod-app-sg"
  description = "Allow traffic only from Web Tier"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "prod-db-sg"
  description = "Allow MySQL traffic only from App Tier"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Call the EC2 Module for the Web Tier (Public)
module "web_tier" {
  source            = "../../modules/ec2"
  server_name       = "prod-web"
  ami_id            = "ami-0aaa636894689fa47" # Amazon Linux 2023 (us-east-1)
  instance_type     = "t3.micro"
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = aws_security_group.web_sg.id
  user_data_script  = templatefile("web.sh.tpl", {
    app_ip = module.app_tier.private_ips[0]
  })
}

# 4. Call the EC2 Module for the Application Tier (Private)
module "app_tier" {
  source            = "../../modules/ec2"
  server_name       = "prod-app"
  ami_id            = "ami-0aaa636894689fa47" 
  instance_type     = "t3.micro"
  subnet_ids        = module.vpc.app_subnet_ids
  security_group_id = aws_security_group.app_sg.id
  user_data_script  = templatefile("app.sh.tpl", {
    # Splits "url:3306" and grabs just the "url" part (index 0)
    db_endpoint = split(":", module.database_tier.db_endpoint)[0] 
    db_password = "SuperSecurePass123!" 
  })
}

# 5. Call the RDS Module for the Database Tier (Private)
module "database_tier" {
  source            = "../../modules/rds"
  db_name           = "ecommerce_db"
  db_username       = "dbadmin"
  db_password       = "SuperSecurePass123!" # Note: Use variables or Secrets Manager in a real prod environment
  subnet_ids        = module.vpc.db_subnet_ids
  security_group_id = aws_security_group.db_sg.id
}