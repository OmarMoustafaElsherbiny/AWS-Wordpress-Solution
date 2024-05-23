# used by ec2 module
output "private_subnets_id" {
  description = "The ID of the private subnets"
  value = values(aws_subnet.private)[*].id
}

output "public_subnets_id" {
  description = "The ID of the public subnets"
  value = values(aws_subnet.public)[*].id
}

# used by other modules and resources
output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.this[0].id
}

output "ec2_private_subnets" {
  description = "Map of EC2 private subnets"
  value = {"0" = aws_subnet.private[0], "1" = aws_subnet.private[1]}
}