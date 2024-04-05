# Add these subnets to atleast 2 AZs later, they are now in one AZ
resource "aws_subnet" "public" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet. Usable range: 15.0.0.1/21 - 15.0.7.254/21 (2,048 - 2)
  cidr_block = "15.0.0.0/21"

  # The AZ for the subnet
  availability_zone = "us-east-1a"

  # Enable public IP address
  map_public_ip_on_launch = true

  # Map of tags to assign to the resource.
  tags = {
    Name        = "public subnet - ${local.project} - ${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    VPC         = aws_vpc.main.id
    Environment = "${local.environment}"
  }
}

resource "aws_subnet" "private" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet. Usable range: 15.0.8.1/21 - 15.0.15.254/21 (2,048 - 2)
  cidr_block = "15.0.8.0/21"

  # The AZ for the subnet
  availability_zone = "us-east-1b"

  # Map of tags to assign to the resource.
  tags = {
    Name        = "private subnet - ${local.project} - ${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    VPC         = aws_vpc.main.id
    Environment = "${local.environment}"
  }
}
