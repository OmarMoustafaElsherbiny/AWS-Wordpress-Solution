# ids are used to connect to ec2s in private subnet using vpc-ec2-endpoint and ssh
output "instance_ids" {
  value = values(aws_instance.this)[*].id
}

output "ec2_targets" {
  description = "All the ec2 instances to be used in the ALB target group"
  value = aws_instance.this
}