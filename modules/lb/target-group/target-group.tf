#############################################################
############### TARGET GROUP/ Listener Rules  ###############
#############################################################
resource "aws_lb_target_group" "target_group" {
  name = "${var.common.env}-${var.common.project}-tg-api"
  port = var.container_port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id

  health_check {
    interval = 60
    path = var.health_check_path
    port = var.container_port
    timeout = 30
    healthy_threshold =  5
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener_rule" "lb_listener_rule_api" {
  listener_arn = var.aws_lb_listener_arn
  priority = var.priority

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = [var.host_header]
    }
  }
}

output "tg_arn" {
  value = aws_lb_target_group.target_group.arn
}