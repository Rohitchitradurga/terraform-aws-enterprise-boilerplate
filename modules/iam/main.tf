terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

# Example of a standard workload role that can be assumed by EC2 or ECS
resource "aws_iam_role" "workload_role" {
  name = "${var.environment}-${var.component_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.trusted_services # e.g. ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "workload_policy_attachments" {
  count      = length(var.policy_arns)
  role       = aws_iam_role.workload_role.name
  policy_arn = var.policy_arns[count.index]
}

# Instance Profile if needed for EC2
resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = "${var.environment}-${var.component_name}-profile"
  role  = aws_iam_role.workload_role.name
}
