################################################################################
# VPC
################################################################################
resource "aws_vpc" "this" {

  # Create VPC or not
  count = var.create_vpc ? 1 : 0

  # The VPC CIDR block. default is 10.0.0.0/16 
  cidr_block = var.cidr

  # The instance tenancy (not guaranteed on the same rack)
  instance_tenancy     = var.instance_tenancy

  # Enable DNS hostnames
  enable_dns_hostnames = var.enable_dns_hostnames

  # Enable DNS resolution support
  enable_dns_support   = var.enable_dns_support

  # Map/object/dict of tags to assign to the resource.
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

  # Create Internet Gateway or not
  count = var.create_igw ? 1 : 0

  # ID of the VPC that the IGW will attach to.
  vpc_id = aws_vpc.this[0].id

  # Map/object/dict of tags to assign to the resource.
  tags = merge(
    { "Name" = "${var.name}-igw" },
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

  # Map that contains the cidr block and the az it belongs to, using cidr as it's key
  for_each = local.public_subnets

  # Availability zone the subnet should be created in.
  availability_zone = each.value.az

  # The CIDR block for the subnet.
  cidr_block = each.value.cidr

  # The VPC ID the subnet belongs to.
  vpc_id = aws_vpc.this[0].id

  # Enable public IP address
  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch 

  # Map/object/dict of tags to assign to the resource.
  tags = merge(
    { "Name" = "${var.name}-${each.value.cidr}-${each.value.az}" },
    var.public_subnet_tags,
    var.tags
  )
}


resource "aws_route_table" "public" {
  for_each = local.public_subnets

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      "Name" = format(
        "${var.name}-%s-%s-public-rt",
        each.value.az, each.value.cidr,
      ) 
    },
    var.tags,
    var.public_route_table_tags,
  )
}


resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}


resource "aws_route" "public_internet_gateway" {
  for_each = local.public_subnets

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}


# Add route table, rt association

################################################################################
# Private Subnets
################################################################################

locals {
  private_subents = { for i in range(length(var.private_subnets)) : i => {
    az = var.azs[i % length(var.azs)]
    cidr = var.private_subnets[i]
  } }
}

resource "aws_subnet" "private" {

  # Map that contains the cidr block and the az it belongs to, using cidr as it's key
  for_each = local.private_subents 

  # Availability zone the subnet should be created in.
  availability_zone = each.value.availability_zone

  # The CIDR block for the subnet.
  cidr_block = each.value.cidr_block

  # The VPC ID the subnet belongs to.
  vpc_id = aws_vpc.this.id

  # Map/object/dict of tags to assign to the resource.
  tags = merge(
    { "Name" = "${var.name}-${each.value.cidr_block}-${each.value.az}" },
    var.private_subnet_tags,
    var.tags
  ) 
  
}

# Add nat gateway and give the option to create more than for each az and subnet (for redundancy by high price)