################################################################################
# VPC
################################################################################
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block = var.cidr

  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}


################################################################################
# Public Subnets
################################################################################

locals {
  public_subnets = { for i in range(length(var.public_subnets)) : i => {
    az = var.azs[i % length(var.azs)]
    cidr = var.public_subnets[i]
  } }
}

resource "aws_subnet" "public" {
  for_each = { for i in range(length(var.public_subnets)) : i => {
    # use modulo to never go out of list range in case the az is shorter than public subnets cidr (from cryptographic algorithms)
    availability_zone = var.azs[i % length(var.azs)]
    cidr_block        = var.public_subnets[i]
  } }

  availability_zone = each.value.availability_zone

  cidr_block = each.value.cidr_block

  vpc_id = aws_vpc.this.id

  # Enable public IP address
  map_public_ip_on_launch = true

  # Map of tags to assign to the resource.
  tags = {
  }
}


resource "aws_subnet" "private" {
  for_each = { for i in range(length(var.private_subnets)) : i => {
    # use modulo to never go out of list range in case the az is shorter than public subnets cidr (from cryptographic algorithms)
    availability_zone = var.azs[i % length(var.azs)]
    cidr_block        = var.private_subnets[i]
  } }

  availability_zone = each.value.availability_zone

  cidr_block = each.value.cidr_block

  vpc_id = aws_vpc.this.id

  # Map of tags to assign to the resource.
  tags = {
  }
}
