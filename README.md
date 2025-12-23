# Terraform AWS Enterprise Boilerplate

[![Terraform Enterprise Pipeline](https://github.com/Rohitchitradurga/terraform-aws-enterprise-boilerplate/actions/workflows/terraform.yaml/badge.svg)](https://github.com/Rohitchitradurga/terraform-aws-enterprise-boilerplate/actions/workflows/terraform.yaml)

A production-ready Reference Architecture and Modular Terraform Boilerplate for building secure, scalable, and compliant AWS environments. This project demonstrates enterprise best practices for Infrastructure as Code (IaC), security, networking, and CI/CD.

##  Features

- **Modular Architecture**: Reusable, standalone modules for Network, IAM, Logging, and Compute.
- **Environment Isolation**: Distinct configurations for `dev`, `staging`, and `prod`.
- **Security First**: 
  - Least-privilege IAM roles.
  - Encrypted S3 buckets and CloudWatch logs using KMS.
  - Private subnets and NAT Gateways by default.
- **CI/CD Automation**: GitHub Actions workflow for automated Terraform `fmt`, `validate`, `plan`, and `apply`.
- **Scalability**: Auto Scaling Groups and Launch Templates ready for production workloads.

## 📂 Project Structure

```bash
.
├── modules/                  # Reusable Terraform modules
│   ├── network/              # VPC, Subnets, Internet/NAT Gateways, Route Tables
│   ├── iam/                  # IAM User, Roles, Policies, Permission Boundaries
│   ├── logging/              # Centralized Logging (S3, CloudWatch, KMS)
│   ├── compute/              # EC2, Auto Scaling Groups, Launch Templates
│   └── data-stores/          # RDS, DynamoDB, S3 (Placeholders)
├── environments/             # Environment-specific configurations
│   ├── dev/                  # Development environment (Entry point)
│   ├── staging/              # Staging environment
│   └── prod/                 # Production environment
├── cicd/                     # CI/CD related documentation
├── examples/                 # Sample usage scenarios
└── .github/workflows/        # GitHub Actions Workflows
```

## 🛠 Modules

### Network
Creates a robust VPC network topology including:
- Public and Private subnets across multiple Availability Zones.
- Internet Gateway and NAT Gateway (configurable).
- Route Tables and associations.

### IAM
Manages Identity and Access Management:
- Standard workload roles (e.g., for EC2/ECS).
- Instance Profiles.
- Custom Trust Policies.

### Logging
Centralized logging solution:
- S3 Bucket for logs with Versioning and Encryption enabled.
- CloudWatch Log Groups.
- KMS Keys for encryption.

### Compute
Standardized compute resources:
- Launch Templates with standard tagging and monitoring.
- Auto Scaling Groups with dynamic scaling policies.

## 🚀 Deployment Guide

### Prerequisites
- [Terraform](https://www.terraform.io/) >= 1.0.0
- AWS Credentials configured locally (for local runs)

### Quick Start (Dev)

1. **Navigate to the dev environment:**
   ```bash
   cd environments/dev
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Plan the deployment:**
   ```bash
   terraform plan
   ```

4. **Apply constraints:**
   ```bash
   terraform apply
   ```

### CI/CD Pipeline
The project includes a GitHub Actions workflow `.github/workflows/terraform.yaml` that automatically runs:
- `terraform fmt -check`
- `terraform validate`
- `terraform plan` (on Pull Requests)
- `terraform apply` (on Merge to main)

## 🔒 Security Best Practices
- **State Management**: Uses remote backend (S3 + DynamoDB) to ensure state file security and locking (configuration to be enabled in `main.tf`).
- **Encryption**: All data at rest (S3, Logs) is encrypted via KMS.
- **Networking**: Application logic sits in private subnets; only load balancers (not included in boilerplate yet) or NAT Gateways reside in public subnets.

## 📄 License
MIT License
