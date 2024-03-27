# variable "tfc_organization" {
#   type        = string
#   description = "Value for TFC organization name"
#   sensitive   = true
# }

# variable "tfc_workspace_name" {
#   type        = string
#   description = "Value for TFC workspace name"
#   sensitive   = true
# }

variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "Value for AWS region"
}
