################################################################################
# EC2 instance IDs for VPC EC2 endpoint
################################################################################
# ids are used to connect to ec2s in private subnet using vpc-ec2-endpoint and ssh
output "instance_ids" {
  description = "List of EC2 instance IDs"
  value = values(aws_instance.this)[*].id
}


################################################################################
# ALB Target Group
################################################################################

output "ec2_targets" {
  description = "All the ec2 instances to be used in the ALB target group"
  value = aws_instance.this
}