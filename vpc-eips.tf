resource "aws_eip" "nat_eip" {
  # EIP used in VPCs
  domain = "vpc"

  # Map of tags to assign to the resource.
  tags = {
    Name        = "NAT EIP - ${local.environment} - ${local.project}"
    Environment = "${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    VPC         = aws_vpc.main.id
  }

  depends_on = [aws_internet_gateway.main]
}
