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
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create_igw ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
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
  for_each = public_subnets

  # Availability zone the subnet should be created in.
  availability_zone = each.value.az

  # The CIDR block for the subnet.
  cidr_block = each.value.cidr

  # The VPC ID
  vpc_id = aws_vpc.this.id

  # Enable public IP address
  map_public_ip_on_launch = true

  # Map of tags to assign to the resource.
  tags = merge(
    { "Name" = "${var.name}-${each.value.cidr}-${each.value.az}" },
    var.public_subnet_tags,
    var.tags
  )
}

# Add route table, rt association


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

# Add nat gateway and give the option to create more than for each az and subnet (for redundancy by high price)