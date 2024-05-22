variable "name" {
  type        = string
  description = "Load balancer name"
}

variable "lb_sg_id" {
  description = "Load balancer security group id"
}

variable "vpc_id" {
  description = "VPC id"
}

variable "subnet_az1_id" {
  description = "Subnet AZ1 id"
}

variable "subnet_az2_id" {
  description = "Subnet AZ2 id"
}

variable "target_id" {
  description = "Target instance id for target group to attach to"
}

variable "tags" {
  description = "values for tags"
  type        = map(string)
  default     = {}
}

variable "lb_tags" {
  description = "Extra tags for load balancer"
  type = map(string)
  default = {}
}