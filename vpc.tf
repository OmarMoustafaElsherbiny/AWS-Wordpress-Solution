resource "aws_vpc" "network" {

  cidr_block           = "15.0.0.0/20" # usable range: 15.0.0.1/20 - 15.0.15.254/20 (4,096 - 4)
  enable_dns_hostnames = true
  enable_dns_support   = true # DNS resolution
  tags = {
    Name = "virtual network - ${local.environment}"
  }
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.network.id
  cidr_block = "15.0.0.0/21" # usable range: 15.0.0.1/21 - 15.0.7.254/21 (2,048 - 2)

  tags = {
    Name = "public subnet - ${local.environment}"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.network.id
  cidr_block = "15.0.8.0/21" # usable range: 15.0.8.1/21 - 15.0.15.254/21 (2,048 - 2)

  tags = {
    Name = "private subnet - ${local.environment}"
  }
}
