# Terraform AWS 3-Tier Architecture

![Terraform](https://img.shields.io/badge/Terraform-v1.7+-7B42BC?style=flat-square&logo=terraform)
![Cloud](https://img.shields.io/badge/Cloud-AWS-orange?logo=amazonaws)
![CI Status](https://img.shields.io/static/v1?label=CI&message=passing&color=3fb950&style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)


## 1. Introduction

This repository contains a fully automated deployment of a 3-tier architecture on AWS using Terraform and three environnements : dev, stagging, prod. 

 The setup implements industry best practices for scalability, security, and maintainability.

The architecture includes:
- Segmented VPC architecture (web, application, and database tiers)
- High availability across multiple Availability Zones
- Auto Scaling Groups and Load Balancers
- RDS MySQL Multi-AZ support

---

## 2. Architecture Overview

### Components
- **Networking Layer**: VPC, subnets, NAT Gateway, Internet Gateway, route tables
- **Security**: Fine-grained Security Groups separating each tier
- **Web Tier**: Public ALB, EC2 Auto Scaling Group
- **Application Tier**: Internal ALB, EC2 Auto Scaling Group
- **Database Tier**: RDS MySQL with subnet groups

---

## 3. Architecture Overview

<p align="center">
  <img src="./3_tier_architecture.png" alt="Three Tier Architecture" width="1000">
</p>

## 4. Benefits of This Architecture

###  Scalability
- Auto Scaling Groups adjust compute capacity automatically.
- Load Balancers distribute traffic across multiple AZs.

###  Security
- Public exposure limited strictly to the ALB.
- Application and database tiers live entirely in private networks.

###  High Availability
- All tiers span multiple Availability Zones.
- RDS Multi-AZ enhances database resilience.

###  Best Practices
- Modular, readable Terraform code structure
- Tier-isolated subnets
- Principle of least privilege enforced through SG rules

---


## 5. How to Use This Project

### 1. Install Requirements
- Terraform ≥ **1.6**
- AWS CLI ≥ **2.0**
- IAM credentials with appropriate permissions

### 2. Configure AWS CLI
```bash
aws configure --profile <your-profile>
```

### 3. Clone the Repository
```bash
git clone https://github.com/a-grivet/terraform-aws-3tier.git
cd terraform-aws-3tier
```

### 4. Prepare your variables
```bash
cp terraform.tfvars.example terraform.tfvars
```
Update:
- aws_region
- aws_profile
- key_pair_name
- AMI IDs
- db_password

### 5. Initialize Terraform
```bash
terraform init
```

### 6. Plan
```bash
terraform plan
```

### 7. Apply
```bash
terraform apply
```

### 8. Destroy
```bash
terraform destroy
```

---

## 6. References
- Terraform Documentation: https://developer.hashicorp.com/terraform/docs
- AWS Well-Architected Framework: https://aws.amazon.com/architecture/well-architected/
- AWS VPC Docs: https://docs.aws.amazon.com/vpc/latest/userguide
- AWS ELB Docs: https://docs.aws.amazon.com/elasticloadbalancing/latest/application
- AWS RDS Docs: https://docs.aws.amazon.com/rds



