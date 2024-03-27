
resource "aws_nat_gateway" "private_gw" {
  # adding an explicit dependency
  # on the Internet Gateway for the VPC to ensure proper order.

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  # Map of tags to assign to the resource.
  tags = {
    Name        = "NAT Gateway - ${local.environment} - ${local.project}"
    Environment = "${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    VPC         = aws_vpc.main.id
  }

  depends_on = [aws_internet_gateway.main]

}
