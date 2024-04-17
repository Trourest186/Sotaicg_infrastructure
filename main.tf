# Reach metadata from infrastructure state file
data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    region = "${var.region}"
    bucket = "${var.remote_state_bucket}"
    key    = "${var.remote_state_key}"
  }
}

locals {
  common = {
    project = "${var.project}"
    env = "${var.env}"
    region = "${var.region}"
    account_id = "${var.account_id}"
  }

  network = {
    vpc_id = data.terraform_remote_state.infrastructure.output.aws_vpc
    subnet_ids = [data.terraform_remote_state.infrastructure.output.private1_subnet, data.terraform_remote_state.infrastructure.ouput.private2_subnet, data.terraform_remote_state.infrastructure.ouput.private3_subnet]
  }
}

# Create repository for project
module "ecr" {
  source = "./modules/ecr"
  common = local.common
}

module "alb" {
  source = "./modules/lb/alb"
  vpc_id = local.network["vpc_id"]
  subnet_ids = local.network["subnet_ids"]
  dns_cert_arn = var.dns_cert_arn
  common = local.common
}

module "target_group" {
  source = "./modules/lb/target-group"
  common = local.common
  priority = var.priority
  health_check_path = var.health_check_path
  container_port = var.container_port
  host_header = var.host_header
  aws_lb_listener_arn = module.alb.output.aws_lb_listener_arn
  vpc_id = local.network["vpc_id"]

}
# # Create ECS Fargate
# module "ecs" {
#   source = "./modules/ecs"
#   ecs_cluster_name = var.ecs_cluster_name
#   common = local.common
#   ecs = 
#   task_cpu = var.task_cpu
#   internet_cidr_blocks = var.internet_cidr_blocks
# }