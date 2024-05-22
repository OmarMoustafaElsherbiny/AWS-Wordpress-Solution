terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }
  }
}

locals {
  tags = {
    Project     = "Wordpress Solution"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

module "wp-alb" {
  source = "./modules/alb"
  name = "internet-facing-wp-alb"
  vpc_id = module.three_tier_vpc.vpc_id
  lb_sg_id = aws_security_group.alb.id
  subnet_az1_id = module.three_tier_vpc.public_subnets_id[0]
  subnet_az2_id = module.three_tier_vpc.public_subnets_id[1] 
  targets = module.wordpress_instances.ec2_targets

  tags = local.tags

  depends_on = [ module.three_tier_vpc, module.wordpress_instances ]
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

  tags = local.tags
}

module "wordpress_instances" {
  source = "./modules/ec2"

  name = "wordpress"
  
  ec2_azs = ["us-east-1a", "us-east-1b"]
  ec2_subnets_ids = module.three_tier_vpc.private_subnets_id
  security_groups = [aws_security_group.bastion_host.id]

  key_pair = "Bastion host key pair - AWS Wordpress Solution - Dev"  
  tags = local.tags
}