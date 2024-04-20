#############################################################
############### Loadbalancer API/ UI external ###############
#############################################################
resource "aws_security_group" "sg_lb" {
  name        = "${var.common.env}-${var.common.project}-sg-lb"
  description = "SG for load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name               = "${var.common.env}-${var.common.project}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_lb.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.dns_cert_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
    }
  }
}

# resource "aws_lb_listener" "lb_listener_http" {
#   load_balancer_arn = aws_lb.lb.arn
#   port = "80"
#   protocol = "HTTP"

#   default_action {
#     type = "redirect"
#     redirect {
#       protocol = "HTTPS"
#       port = "443"
#       host = "#{host}"
#       path = "/#{path}"
#       query = "#{query}"
#       status_code = "HTTP_301"
#     }
#   }
# }

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.lb.zone_id
}

output "sg_lb" {
  value = aws_security_group.sg_lb.id
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.lb_listener_https.arn
}