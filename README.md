# Production-Ready 3-Tier Infrastructure with Terraform

## Project Overview
This project provisions a highly available, secure, and modular 3-tier architecture on AWS using Terraform. It eliminates manual console deployments and configuration drift by utilizing reusable Infrastructure as Code (IaC) modules for Networking, Compute, and Database tiers.

## Architecture Design
The infrastructure is distributed across two Availability Zones for high availability and follows strict security group chaining.

* **Web Tier (Public):** Nginx reverse proxy servers deployed in public subnets. Accessible via the Internet Gateway.
* **Application Tier (Private):** Apache/PHP backend servers deployed in private subnets. Outbound internet access is routed through a NAT Gateway.
* **Database Tier (Private):** Amazon RDS (MySQL) deployed in isolated database subnets.

### Traffic Flow & Security
`Public Internet (HTTP/S)` ➡️ `Web Security Group` ➡️ `App Security Group` ➡️ `DB Security Group`

## Repository Structure
```text
.
├── environments/
│   └── prod/
│       ├── main.tf             # Root module execution
│       ├── outputs.tf          # Public IPs and DB endpoints
│       ├── web.sh.tpl          # Nginx & Reverse Proxy startup script
│       └── app.sh.tpl          # Apache & PHP backend startup script
└── modules/
    ├── vpc/                    # Custom VPC, Subnets, IGW, NAT, Routing
    ├── ec2/                    # Reusable Compute module
    └── rds/                    # MySQL Database and Subnet Groups
.
```
# Security Best Practices Implemented

1. Network Isolation: Application and Database tiers are placed in private subnets with no public IP addresses.

2. Security Group Chaining: Instead of IP-based rules, security groups reference each other. The Database only accepts traffic from the App Tier, and the App Tier only accepts traffic from the Web Tier.

3. Dynamic Secrets Injection: Database credentials and internal IPs are injected dynamically at runtime via Terraform templatefile() functions, keeping them out of the source code.

4. Outbound Traffic Control: Private instances use a NAT Gateway, ensuring they can fetch updates securely without being exposed to inbound internet traffic.

# Deployment Steps

1. **Clone the repository:** git clone <your-repo-url>

2. **Navigate to the production environment:** cd environments/prod

3. **Initialize Terraform:** terraform init

4. **Review the execution plan:** terraform plan

5. **Provision the infrastructure:** terraform apply --auto-approve

6. **Access the application:** Copy the web_server_public_ips from the output and paste it into your browser to test the full 3-tier data flow.
