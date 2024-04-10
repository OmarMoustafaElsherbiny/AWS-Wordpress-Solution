resource "aws_lb" "wordpress" {
  name               = "Wordpresslb - ${local.environment}"
  # Internet facing scheme 
  internal           = false
  # Application layer (TCP/IP - OSI) load balancer
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public.id]
  enable_deletion_protection = false

  tags = {
    Environment = "${local.environment}"
    ManagedBy   = "${local.managedBy}"
    Project     = "${local.project}"
    VPC         = aws_vpc.main.id
  }
}

# TODO: Test RDS with Wordpress first before provisioning the ALB
resource "aws_lb_target_group" "wordpress" {
  name     = "wordpress-tg"
  target_type = "ip"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled = true
    interval = 300
    path = "/"
    timeout = 60
    matcher = 200
    healthy_threshold = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}

# The application load balancer

resource "aws_lb_target_group_attachment" "web_servers" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = aws_instance.bastion_host.id
  port             = 80
}