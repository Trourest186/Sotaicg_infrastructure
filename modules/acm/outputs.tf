output "dns_cert_arn" {
  value = aws_acm_certificate.ecs_domain_certificate.arn
}