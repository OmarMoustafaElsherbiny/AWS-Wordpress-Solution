resource "aws_route_table" "public" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # Route table entry
  route {
    # The destination CIDR block
    cidr_block = "0.0.0.0/0"

    # ID of a VPC internet gateway or virtual private gateway.
    gateway_id = aws_internet_gateway.main.id
  }

  # Map of tags to assign to the resource.
  tags = {
    Name        = "public route table - ${local.project} - ${local.environment}"
    Environment = "${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    VPC         = aws_vpc.main.id
  }
}

resource "aws_route_table" "private" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # Route table entry
  route {
    # The destination CIDR block
    cidr_block = "0.0.0.0/0"

    # ID of a VPC internet gateway or virtual private gateway.
    gateway_id = aws_nat_gateway.private_gw.id
  }

  # Map of tags to assign to the resource.
  tags = {
    Name        = "private route table - ${local.project} - ${local.environment}"
    Environment = "${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    VPC         = aws_vpc.main.id
  }
}
