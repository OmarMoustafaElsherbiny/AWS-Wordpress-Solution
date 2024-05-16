# subnets the ec2 will be deployed in
variable "ec2_subnets_ids" {
  type = list(string)
  default = []
}

variable "ec2_azs" {
  type = list(string)
  default = []
}

variable "associate_public_ip_address" {
  type = bool
  default = false
}