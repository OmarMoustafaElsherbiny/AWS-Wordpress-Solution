################################################################################
# EC2 Configuration
################################################################################

variable "ec2_subnets" {
  description = "List of subnets the ec2 will be deployed in"
}

# Gives public ip address to the instance (use in public subnet)
# Dynamic or Elastic IP (static) public ips
variable "associate_public_ip_address" {
  description = "Associate a public IP address with an instance in a VPC"
  type = bool
  default = false
}

variable "instance_ami" {
  description = "EC2 instance AMI"
  type = string
  default = "ami-0c101f26f147fa7fd"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t2.micro"
}

variable "key_pair" {
  description = "key pair name"
  type = string
}

variable "security_groups" {
  description = "List of security groups to be attached to the instance"
  type = set(string)
  default = []
}

################################################################################
# Tags & EC2 name
################################################################################


variable "name" {
  description = "name of the ec2 instance"
  type = string
  default = ""
}

variable "tags" {
  description = "Additional tags for the EC2 instance"
  type = map(string)
  default = {}
}

variable "ec2_tags" {
  description = "Tags to be applied to the EC2 instance"
  type = map(string)
  default = {}
}