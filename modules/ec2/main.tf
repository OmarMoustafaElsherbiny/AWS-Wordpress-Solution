locals {
  ec2_subnets = {for i in range(length(var.ec2_subnets_ids)) : i =>  {
    az = var.ec2_azs[i],
    subnet_id = var.ec2_subnets_ids[i]
  }}
}
resource "aws_instance" "this" {

  for_each = local.ec2_subnets

  subnet_id = each.value.subnet_id

  availability_zone = each.value.az

  ami = "ami-0c101f26f147fa7fd"

  instance_type = "t2.micro"

  associate_public_ip_address = var.associate_public_ip_address

  key_name = "Bastion host key pair - AWS Wordpress Solution - Dev"
  tags = {
    Name        = ""
    ManagedBy   = ""
    Project     = ""
    Environment = ""
  }
}