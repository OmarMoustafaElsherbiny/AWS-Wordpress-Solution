################################################################################
# Wordpress Instances Security Group
################################################################################
resource "aws_security_group" "wordpress_instances" {
  # Security group name
  name = "wp-sg"

  # The VPC ID
  vpc_id = module.three_tier_vpc.vpc_id

  # This won't work since the instance is in a private subnet
  # Require internet gateway to reach the instance
  # Test with ec2 instance connect to see if we remove this rule, will it still work ?
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic with any protocol
  # Since all protocols are allowed you dont need to add MySQL ports or HTTP rules for downloads
  # Require NAT Gateway to access the internet with egress, Since EC2 instances are in a private subnet.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Here a security group rule resource is used to prevent cyclic dependency error
# Allow inboound HTTP access from anywhere (for testing purposes)
resource "aws_security_group_rule" "http_bastion_traffic" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.wordpress_instances.id
  source_security_group_id = aws_security_group.alb.id
}

################################################################################
# Database Security Group
################################################################################
resource "aws_security_group" "db_instance" {
  # Security group name
  name = "db-sg"

  # The VPC ID
  vpc_id = module.three_tier_vpc.vpc_id

  # Allow MySQL access from the WordPress instances only
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.wordpress_instances.id]
  }
  # Allow all outbound traffic with any protocol
  # Requires NAT Gateway to access the internet with egress
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


################################################################################
# Application Load Balancer Security Group
################################################################################
resource "aws_security_group" "alb" {
  # Security group name
  name = "alb-sg"

  # The VPC ID
  vpc_id = module.three_tier_vpc.vpc_id

  # Allow inbound HTTP access from anywhere on the Internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow all outbound traffic with any protocol only to the WordPress instances
# For health checks
resource "aws_security_group_rule" "egress_alb_traffic" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.alb.id
  source_security_group_id = aws_security_group.wordpress_instances.id
}