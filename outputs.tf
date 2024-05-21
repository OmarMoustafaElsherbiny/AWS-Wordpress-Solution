output "bastion_hostname" {
  value       = aws_instance.bastion_host.public_dns
  description = "The public domain of the bastion host"
}

output "bastion_ipv4_address" {
  value       = aws_instance.bastion_host.public_ip
  description = "The public IP address of the bastion host"
}

output "rds_endpoint" {
  value       = aws_db_instance.default.endpoint
  description = "The RDS endpoint"
}

output "alb_dns_name" {
  value       = module.wp-alb.alb_dns_name
  description = "The DNS name of the ALB from ALB module"
}

output "ec2s_insatance_ids" {
  value = module.ec2s.ec2_instance_id 
}

output "ec2_instance_id_1" {
  value = module.ec2s.instance_ids[0] 
}

output "ec2_instance_id_2" {
  value = module.ec2s.instance_ids[1] 
}