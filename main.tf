terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }
  }
}

locals {
  environment = "Dev"
  managedBy   = "Terraform"
  project     = "AWS Wordpress Solution"
}

module "wp-alb" {
  source = "./modules/alb"
  alb_name = "wordpress"
  vpc_id = aws_vpc.main.id
  lb_sg_id = aws_security_group.alb.id
  subnet_az1_id = aws_subnet.public.id
  target_id = aws_instance.bastion_host.id
}