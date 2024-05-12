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
  project     = "Wordpress Solution"
}

module "wp-alb" {
  source = "./modules/alb"
  alb_name = "wordpress"
  vpc_id = aws_vpc.main.id
  lb_sg_id = aws_security_group.alb.id
  subnet_az1_id = aws_subnet.public.id
  subnet_az2_id = aws_subnet.private.id
  target_id = aws_instance.bastion_host.private_ip

  depends_on = [ aws_instance.bastion_host ]
}

module "three_tier_vpc" {
  source = "./modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24",
                    "10.0.103.0/24", "10.0.104.0/24"]

  public_subnet_map_public_ip_on_launch = true

  create_ec2_endpoint = true

  tags = {
    "Project" = local.project 
    "ManagedBy" = local.managedBy 
    "Environment" = local.environment 
  }
}