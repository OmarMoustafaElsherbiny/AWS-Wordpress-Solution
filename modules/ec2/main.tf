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

  ami = var.instance_ami 

  instance_type = var.instance_type 

  associate_public_ip_address = var.associate_public_ip_address

  key_name = var.key_pair 

  security_groups = var.security_groups

  tags = merge(
    { "Name" = format("${var.name}-%s-%s", each.value.az, each.value.subnet_id)
    }, 
    var.tags, 
    var.ec2_tags
  )
}