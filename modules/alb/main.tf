resource "aws_lb" "application" {
  name               = "${var.alb_name}"
  # Internet facing scheme 
  internal           = false
  # Application layer (TCP/IP - OSI) load balancer
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = [var.subnet_az1_id]
  enable_deletion_protection = false

  tags = {
    ManagedBy   = "Terraform"
    VPC         = "${var.vpc_id}"
  }
}

# TODO: Test RDS with Wordpress first before provisioning the ALB
resource "aws_lb_target_group" "main" {
  name     = "${var.alb_name}-tg"
  target_type = "ip"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

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

# listener for http that forward traffic to web servers
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}


resource "aws_lb_target_group_attachment" "web_servers" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = "${var.target_id}"
  port             = 80
}