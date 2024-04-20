################## ROUTE53 DNS  #####################
resource "aws_route53_record" "record" {
  zone_id = var.hosted_zone_public_id
  name    = var.host_header
  type    = "A"
  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = false
  }
}