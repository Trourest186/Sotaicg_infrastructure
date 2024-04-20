########################################################
####  ECS role - task definitions - servivices #########
########################################################
resource "aws_security_group" "app_security_group" {
  name        = "${var.common.env}-${var.common.project}-sg-${var.name}"
  description = "SG for ${var.name} group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

}

### Create cluster for ECS 
resource "aws_ecs_cluster" "production-fargate-cluster" {
  name = "Production-Fargate-Cluster"
}

### ECS SERVICE ###
## Create cloudwatch for ECS services
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "ecs/${var.common.env}-${var.common.project}-${var.name}"
}

## Create task-definite
data "template_file" "ecs_task_definition_template" {
  template = file("./modules/ecs/task_definition.json")

  vars = {
    task_definition_name  = "${var.common.env}-${var.common.project}-${var.name}"
    logs_service_name      ="ecs/${var.common.env}-${var.common.project}-${var.name}"
    docker_image_url      = "${var.common.account_id}.dkr.ecr.${var.common.region}.amazonaws.com/${var.common.env}-${var.common.project}-base:latest"
    spring_profile        = "${var.spring_profile_ecs}"
    region                = "${var.common.region}"
    docker_container_port = "${var.container_port_ecs}"
  }

}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = "${data.template_file.ecs_task_definition_template.rendered}"
  family = "${var.common.env}-${var.common.project}-${var.name}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${aws_iam_role.fargate_iam_role.arn}"
  task_role_arn            = "${aws_iam_role.fargate_iam_role.arn}"
  cpu = var.task_cpu
  memory = var.task_ram

  depends_on = [aws_cloudwatch_log_group.ecs_log_group]
}

resource "aws_ecs_service" "ecs_sercive" {
  name = "${var.common.env}-${var.common.project}-${var.name}"
  cluster = aws_ecs_cluster.production-fargate-cluster.name
  task_definition =  aws_ecs_task_definition.task_definition.arn
  lifecycle {
    ignore_changes = [task_definition]
  }
  launch_type = "FARGATE"
  platform_version = "1.4.0"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  desired_count = var.desired_count

  network_configuration {
    assign_public_ip = true
    subnets = var.subnet_ids # Need input from state file
    security_groups = [aws_security_group.app_security_group.id]
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_port = var.container_port_ecs
    container_name = "${var.common.env}-${var.common.project}-${var.name}"
  }

  # depends_on = [aws_ecs_task_definition.task_definition]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = var.max_containers
  min_capacity = var.min_containers
  resource_id = "service/${aws_ecs_cluster.production-fargate-cluster.name}/${aws_ecs_service.ecs_sercive.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  # role_arn = var.ecs.role_auto_scaling
  # lifecycle {
  #   ignore_changes = [role_arn]
  # }
}

# Scale with CPU
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name = "${var.common.env}-${var.common.project}-AutoScalingPolicyCPU-for-${var.name}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown = "30"
    scale_out_cooldown = "30"
    target_value = var.auto_scaling_target_value_cpu
  }
}

# Scale with RAM
resource "aws_appautoscaling_policy" "ecs_policy_ram" {
  name = "${var.common.env}-${var.common.project}-AutoScalingPolicyRAM-for-${var.name}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_in_cooldown = "30"
    scale_out_cooldown = "30"
    target_value = var.auto_scaling_target_value_ram
  }
}

# Policy
resource "aws_iam_role" "fargate_iam_role" {
  name = "${var.ecs_cluster_name}-IAM-Role"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
 {
   "Effect": "Allow",
   "Principal": {
     "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
   },
   "Action": "sts:AssumeRole"
  }
  ]
 }
EOF
}

resource "aws_iam_role_policy" "fargate_iam_policy" {
  name = "${var.ecs_cluster_name}-IAM-Role"
  role = aws_iam_role.fargate_iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ],
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
  listener_arn = var.aws_lb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }

  condition {
    host_header {
      values = ["${lower("${var.common.env}-${var.common.project}-${var.name}")}.${var.domain_name}"]
    }
  }
}