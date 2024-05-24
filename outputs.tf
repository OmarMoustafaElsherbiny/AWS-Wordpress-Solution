################################################################################
# Endpoints 
################################################################################

# instead of MySQL container name as the endpoint, we use RDS & in the CI workflow it edits the playbook to add the endpoint
output "rds_endpoint" {
  value       = aws_db_instance.default.endpoint
  description = "The RDS endpoint to be used with wordpress"
}

output "alb_dns_name" {
  value       = module.wp-alb.alb_dns_name
  description = "The DNS name of the ALB for the user to connect to"
}


################################################################################
# Ansible variables
################################################################################

output "ec2s_insatance_ids" {
  value = module.wordpress_instances.instance_ids
  description = "List of EC2 instance IDs for Ansible to use with SSH & AWS CLI to connect to the instances"
}

output "ec2_instance_id_1" {
  value = module.wordpress_instances.instance_ids[0] 
  description = "Instance ID of the first EC2 instance used in Ansible SSH proxy command to connect to the instance"
}

output "ec2_instance_id_2" {
  value = module.wordpress_instances.instance_ids[1] 
  description = "Instance ID of the second EC2 instance used in Ansible SSH   proxy command to connect to the instance"
}