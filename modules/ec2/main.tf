locals {
  ec2_subnets = {for i in range(length(var.var.ec2_subnets)) : i =>  {
    az = var.ec2_azs[i],
    subnet = var.var.ec2_subnets[i]
  }}
}
resource "aws_instance" "this" {

  for_each = local.ec2_subnets

  subnet_id = each.key.subnet

  availability_zone = each.value.az

  ami = "ami-0c101f26f147fa7fd"

  instance_type = "t2.micro"

  associate_public_ip_address = true

  key_name = "Bastion host key pair - AWS Wordpress Solution - Dev"
  tags = {
    Name        = ""
    ManagedBy   = ""
    Project     = ""
    Environment = ""
  }
}