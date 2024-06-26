################################################################################
# Load Balancer 
################################################################################

resource "aws_lb" "application" {
  name               = "${var.name}"
  # Internet facing scheme 
  internal           = false
  # Application layer (TCP/IP - OSI) load balancer
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = [var.subnet_az1_id, var.subnet_az2_id]
  enable_deletion_protection = false

  tags = merge(
    {
      Name = "${var.name}"
    },
    var.tags,
    var.lb_tags
  )
}
################################################################################
# Listener 
################################################################################


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


################################################################################
# Target Group
################################################################################

resource "aws_lb_target_group" "main" {
  name     = "${var.name}-tg"
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
resource "aws_lb_target_group_attachment" "web_servers" {
  for_each = var.targets
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = each.value.private_ip
  port             = 80
}
