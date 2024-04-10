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
  value       = aws_lb.wordpress.dns_name
  description = "The DNS name of the ALB"
}