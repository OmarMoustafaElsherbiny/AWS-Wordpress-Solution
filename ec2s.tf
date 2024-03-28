# The bastion host/jumpbox that is used to access resources in the private subnet
resource "aws_instance" "bastion_host" {
  # The Subnet ID
  subnet_id = aws_subnet.public.id

  # The AZ the instance is located in
  availability_zone = "us-east-1a"

  # Amazon Linux 2023 AMI ID
  ami = "ami-0c101f26f147fa7fd"

  # The instance type
  instance_type = "t2.micro"

  # Assign a public ip to this instance
  associate_public_ip_address = true

  # Bastion host security group
  security_groups = [aws_security_group.bastion_host.id]

  # Manually created key pair on AWS Console
  key_name = "Bastion host key pair - AWS Wordpress Solution - Dev"

  # Map of tags to assign to the resource.
  tags = {
    Name        = "bastion host - ${local.project} - ${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    Environment = "${local.environment}"
  }
}
