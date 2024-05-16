# used by ec2 module
output "private_subnets_id" {
  description = "The ID of the private subnets"
  value = values(aws_subnet.private)[*].id
}

# used by other modules and resources
output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.this[0].id
}