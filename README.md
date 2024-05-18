# AWS-Wordpress-3-Tier-VPC

## Architecture Diagram

![Wordpress Architecture Diagram](./Diagram/Architecture-Diagram.png)

## Overview
3 Tier VPC that is provisioned using Terraform and instances on the subnet are configured using Ansible.

### Resources

#### VPC resources
- 4 private subnets (2 in each AZ)
- 2 public subnets (1 in each AZ)
- 2 public route tables (1 for each public subnet)
- 4 private route tables
- 2 public NAT gateway (1 for each public subnet)
- VPC EC2 connect endpoint (connect to private instances withou the need for bastion/jumpbox host)
- internet gateway

#### Elastic Load balancer
- 1 internet facing application load balancer

#### EC2
- 2 EC2s instances with amazon linux image

