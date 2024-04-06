resource "aws_lb_target_group" "web_servers" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "web_servers" {
  target_group_arn = aws_lb_target_group.web_servers.arn
  target_id        = aws_instance.bastion_host.id
  port             = 80
}


resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}


resource "aws_lb" "wp_alb" {
  name               = "wp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.bastion_host.id]
  subnets            = [aws_subnet.public.id]

  tags = {
    Environment = "test"
    ManagedBy   = "Terraform"
    Project     = "AWS Wordpress Solution"
    VPC         = aws_vpc.main.id
  }
}
