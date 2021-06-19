output "target_group_arn" {
  value = aws_lb_target_group.lab.arn
}

output "dns_name" {
  value = aws_lb.lab.dns_name
}
