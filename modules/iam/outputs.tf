output "role_name" {
  description = "Name of the created execution role"
  value       = aws_iam_role.workload_role.name
}

output "role_arn" {
  description = "ARN of the created execution role"
  value       = aws_iam_role.workload_role.arn
}

output "instance_profile_name" {
  description = "Name of the instance profile"
  value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
}
