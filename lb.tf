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

