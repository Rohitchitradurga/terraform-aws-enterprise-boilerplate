variable "environment" {
  description = "Environment name"
  type        = string
}

variable "component_name" {
  description = "Name of the component/service"
  type        = string
}

variable "trusted_services" {
  description = "List of services that can assume this role"
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "policy_arns" {
  description = "List of policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
