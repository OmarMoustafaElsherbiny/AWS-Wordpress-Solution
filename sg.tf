resource "aws_security_group" "bastion_host" {
  # Security group name
  name = "bastion-sg"

  # The VPC ID
  vpc_id = aws_vpc.main.id

  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow inboound HTTP access from anywhere (for testing purposes)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [ aws_security_group.alb.id ]
  }
  # Allow all outbound traffic with any protocol
  # Since all protocols are allowed you dont need to add MySQL ports or HTTP rules for downloads
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_instance" {
  # Security group name
  name = "db-sg"

  # The VPC ID
  vpc_id = aws_vpc.main.id

  # Allow MySQL access from the bastion host
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }
  # Allow all outbound traffic with any protocol
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "alb" {
  # Security group name
  name = "alb-sg"

  # The VPC ID
  vpc_id = aws_vpc.main.id

  # Allow inbound HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic to flow to bastion host temporarily for testing
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_security_group.bastion_host.id]
  }
}
