output "alb_dns_name" {
  value       = aws_lb.application.dns_name
  description = "The DNS name of the application load balancer"
}

output "alb_tg_arn" {
  value = aws_lb_target_group.main.arn
  description = "The ARN of the application load balancer target group"
}

output "alb_zone_id" {
  value = aws_lb.application.zone_id
  description = "The zone ID of the application load balancer"
}