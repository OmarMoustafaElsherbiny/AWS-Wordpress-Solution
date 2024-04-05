resource "aws_db_subnet_group" "db_azs" {
  # Name of the DB subnet group
  name       = "main"
  # Subnets the DB can be provisioned in
  # TODO: Test it in the public subnet and later in the private subnet
  subnet_ids = [aws_subnet.public.id]
}

resource "aws_db_instance" "default" {
  db_name              = "wp-db"
  engine               = "mysql"

  # Recommended version req for wordpress instead of the v5.7 in the ansible playbook
  engine_version       = "8.0.23"

  # Deploy RDS in a single AZ to save costs
  multi_az = false

  # Must be unique in the AWS region namespace
  identifier = "database-24"
  username             = "exampleuser"
  password             = "examplepass"
  instance_class       = "db.t2.micro"
  allocated_storage    = 200
  db_subnet_group_name = aws_db_subnet_group.db_azs.name
  vpc_security_group_ids = [aws_db_subnet_group.db_azs.id]
  # The AZ the instance will be provisioned in
  availability_zone = "us-east-1a"
  skip_final_snapshot  = true
}
