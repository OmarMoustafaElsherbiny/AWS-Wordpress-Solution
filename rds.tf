resource "aws_db_subnet_group" "db_azs" {
  name = "wp-db-subnets"
  # Subnets the DB can be provisioned in for Multi-AZ deployments and replication
  subnet_ids = [module.three_tier_vpc.private_subents["2"].id, module.three_tier_vpc.private_subents["3"].id]
  tags = local.tags
}

resource "aws_db_instance" "default" {
  # Must be unique in the AWS region namespace
  identifier = "wordpress-db"
  engine     = "mysql"

  # Recommended version req for wordpress instead of the v5.7 in the ansible playbook
  engine_version = "8.0"

  # Deploy RDS in a single AZ to save costs
  multi_az = false

  db_name                = "wordpressdb"
  username               = "exampleuser"
  password               = "examplepass"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.db_azs.name
  vpc_security_group_ids = [aws_security_group.db_instance.id]
  # The AZ the instance will be provisioned in
  availability_zone   = "us-east-1a"
  skip_final_snapshot = true
}
