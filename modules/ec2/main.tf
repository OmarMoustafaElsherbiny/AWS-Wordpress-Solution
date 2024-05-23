resource "aws_instance" "this" {

  # For each subnet create an ec2
  for_each = var.ec2_subnets

  # subnet the ec2 should be placed in (from the subnet map)
  subnet_id = each.value.id

  # availability zone the ec2 should be created in (from subnet map)
  availability_zone = each.value.availability_zone

  # EC2 instance AMI
  ami = var.instance_ami 

  # EC2 instance type
  instance_type = var.instance_type 

  # Give the instance a public ip
  associate_public_ip_address = var.associate_public_ip_address

  # key pair (for SSH access)
  key_name = var.key_pair 

  # security groups to be attached to the instance
  security_groups = var.security_groups

  # Tags to be applied to the EC2 instance
  tags = merge(
    { "Name" = format("${var.name}-%s-%s", each.value.az, each.value.subnet_id)
    }, 
    var.tags, 
    var.ec2_tags
  )
}