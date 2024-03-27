resource "aws_vpc" "main" {
  # The VPC CIDR block. Usable range: 15.0.0.1/20 - 15.0.15.254/20 (4,096 - 4)
  cidr_block = "15.0.0.0/20"

  # The instance tenancy (not guaranteed on the same rack)
  instance_tenancy = "default"

  # Enable DNS hostnames
  enable_dns_hostnames = true

  # Enable DNS resolution support
  enable_dns_support = true

  # Map of tags to assign to the resource.
  tags = {
    Name        = "virtual isolated network - ${local.project} - ${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    Environment = "${local.environment}"
  }
}


resource "aws_internet_gateway" "main" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # Map of tags to assign to the resource.
  tags = {
    Name        = "internet gateway - ${local.project} - ${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    Environment = "${local.environment}"
  }
}
