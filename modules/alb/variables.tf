################################################################################
# Load Balancer Security Group & VPC 
################################################################################

variable "lb_sg_id" {
  description = "Load balancer security group id"
}

variable "vpc_id" {
  description = "VPC id"
}

################################################################################
# The application load balancer targets 
################################################################################

variable "targets" {
  description = "List of EC2 instance targets"
}

################################################################################
# Load Balancer Subnets
################################################################################


variable "subnet_az1_id" {
  description = "Subnet AZ1 id"
}

variable "subnet_az2_id" {
  description = "Subnet AZ2 id"
}

################################################################################
# Tags & LB name
################################################################################
variable "name" {
  type        = string
  description = "Load balancer name"
}

variable "tags" {
  description = "Values for tags"
  type        = map(string)
  default     = {}
}

variable "lb_tags" {
  description = "Extra tags for load balancer"
  type = map(string)
  default = {}
}