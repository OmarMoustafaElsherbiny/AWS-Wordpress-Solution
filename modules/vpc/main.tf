resource "aws_vpc" "this" {
  
}

resource "aws_subnet" "public" {
  for_each = { for i in range(length(var.public_subnets)) : i => {
    # use modulo to never go out of list range in case the az is shorter than public subnets cidr (from cryptographic algorithms)
    availability_zone = var.azs[i % length(var.azs)]
    cidr_block       = var.public_subnets[i]
  }}
  
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
    cidr_block       = var.private_subnets[i]
  }}
  
  availability_zone = each.value.availability_zone

  cidr_block = each.value.cidr_block

  vpc_id = aws_vpc.this.id

  # Map of tags to assign to the resource.
  tags = {
  }
}