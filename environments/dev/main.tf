terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }

  # Backend configuration - usually configured via partial config or specific file
  # backend "s3" {
  #   bucket         = "my-org-terraform-state"
  #   key            = "dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "my-org-terraform-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "enterprise-boilerplate"
      ManagedBy   = "Terraform"
    }
  }
}

module "network" {
  source = "../../modules/network"

  vpc_cidr             = "10.0.0.0/16"
  environment          = "dev"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.11.0/24"]
  enable_nat_gateway   = true
}

module "logging" {
  source = "../../modules/logging"

  environment    = "dev"
  project_name   = "enterprise-boilerplate"
  region         = var.region
  retention_days = 7
}

module "app_iam" {
  source = "../../modules/iam"

  environment             = "dev"
  component_name          = "web-app"
  trusted_services        = ["ec2.amazonaws.com"]
  policy_arns             = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"] # Example policy
  create_instance_profile = true
}

module "compute" {
  source = "../../modules/compute"

  environment               = "dev"
  component_name            = "web-app"
  ami_id                    = "ami-0cff7528ff583bf9a" # Amazon Linux 2 (example)
  instance_type             = "t3.micro"
  iam_instance_profile_name = module.app_iam.instance_profile_name
  subnet_ids                = module.network.private_subnet_ids
  security_group_ids        = [aws_security_group.app_sg.id]
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
}

resource "aws_security_group" "app_sg" {
  name        = "dev-app-sg"
  description = "Security group for web app"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from everywhere (example)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
