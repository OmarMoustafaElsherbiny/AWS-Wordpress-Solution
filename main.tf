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

# module "wp-alb" {
#   source = "./modules/alb"
#   alb_name = "wordpress"
#   vpc_id = aws_vpc.main.id
#   lb_sg_id = aws_security_group.alb.id
#   subnet_az1_id = aws_subnet.public.id
#   subnet_az2_id = aws_subnet.private.id
#   target_id = aws_instance.bastion_host.private_ip

#   depends_on = [ aws_instance.bastion_host ]
# }

# Test EC2 with wordpress and RDS but without the ALB, just delete the module arguments from the main.tf