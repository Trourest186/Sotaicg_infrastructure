########################################################
####  ECS role - task definitions - servivices #########
########################################################
resource "aws_security_group" "sg_service" {
  name        = "${var.common.env}-${var.common.project}-sg-${var.name}"
  description = "SG for ${var.name} group"
  vpc_id      = var.network.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
  template = file("task_definition.json")

  vars = {
    task_definition_name  = "${var.container_name}"
    logs_service_name      ="ecs/${var.common.env}-${var.common.project}-${var.name}"
    docker_image_url      = "${var.common.account_id}.dkr.ecr.${var.common.region}.amazonaws.com/${var.common.env}-${var.common.project}-${var.container_name}:latest"
    spring_profile        = "${var.spring_profile}"
    region                = "${var.common.region}"
    docker_container_port = "${var.container_port}"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = "${data.template_file.ecs_task_definition_template.rendered}"
  family = "${var.common.env}-${var.common.project}-${var.name}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = var.ecs.role_execution
  task_role_arn = var.ecs.role_ecs_service
  cpu = var.task_cpu
  memory = var.task_ram

  depends_on = [aws_cloudwatch_log_group.log_group]
}

resource "aws_ecs_service" "ecs_sercive" {
  name = "${var.common.env}-${var.common.project}-${var.name}"
  cluster = aws_ecs_cluster.production-fargate-cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
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
    subnets = var.network.subnet_ids # Need input from state file
    security_groups = [aws_security_group.sg_service.id, var.network.sg_container]
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_port = var.container_port
    container_name = var.name
  }

  # depends_on = [aws_lb_listener_rule.lb_listener_rule]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = var.max_containers
  min_capacity = var.min_containers
  resource_id = "service/${var.ecs.ecs_cluster_name}/${aws_ecs_service.ecs_sercive.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  role_arn = var.ecs.role_auto_scaling
  lifecycle {
    ignore_changes = [role_arn]
  }
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