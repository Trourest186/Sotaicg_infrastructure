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
    project    = "${var.project}"
    env        = "${var.env}"
    region     = "${var.region}"
    account_id = "${var.account_id}"
  }

  network = {
    vpc_id         = data.terraform_remote_state.infrastructure.outputs.aws_vpc
    subnet_ids     = [data.terraform_remote_state.infrastructure.outputs.private1_subnet, data.terraform_remote_state.infrastructure.outputs.private2_subnet]
    route_table_id = [data.terraform_remote_state.infrastructure.outputs.private-routetb]
  }
}

# # Create codebuild
# module "codebuild" {
#   source          = "./modules/codebuild-codedeploy-codepipiline/codebuild"
#   project         = var.project
#   env             = var.env
#   region          = var.region
#   name            = var.name_codebuild
#   privileged_mode = var.privileged_mode
#   repo            = var.repo
#   account         = var.account
#   branch          = var.branch
#   env_var         = var.env_var
# }

# # Create for ECS service to interact with ECR
# # module "vpc_endpoints" {
# #   source = "./modules/vpc/vpc_endpoints"
# #   vpc_id = local.network["vpc_id"]
# #   subnet_ids = [data.terraform_remote_state.infrastructure.outputs.private1_subnet, data.terraform_remote_state.infrastructure.outputs.private2_subnet, data.terraform_remote_state.infrastructure.outputs.private3_subnet]
# #   route_table_id = local.network["route_table_id"]
# # }

# #Create repository for project
# # module "ecr" {
# #   source = "./modules/ecr"
# #   common = local.common
# # }

#Create application load balancing
# module "alb" {
#   source       = "./modules/lb/alb"
#   vpc_id       = local.network["vpc_id"]
#   subnet_ids   = [data.terraform_remote_state.infrastructure.outputs.public1_subnet, data.terraform_remote_state.infrastructure.outputs.public2_subnet]
#   dns_cert_arn = var.dns_cert_arn
#   common       = local.common
# }

# # Create target group
# module "target_group" {
#   source            = "./modules/lb/target-group"
#   common            = local.common
#   priority          = var.priority
#   health_check_path = var.health_check_path
#   container_port    = var.container_port_ecs
#   # host_header = var.host_header
#   aws_lb_listener_arn = module.alb.aws_lb_listener_arn
#   vpc_id              = local.network["vpc_id"]

# }


# #Create a record for load balancing
# module "route_53" {
#   source                = "./modules/route-53/hostzone-lb"
#   hosted_zone_public_id = var.hosted_zone_public_id
#   host_header           = var.host_header
#   lb_dns_name           = module.alb.lb_dns_name
#   lb_zone_id            = module.alb.lb_zone_id
# }

# # module "acm" {
# #   source = "./modules/acm"
# #   ecs_domain_name = var.ecs_domain_name
# # }

#Create ECS Fargate
# module "ecs" {
#   source                        = "./modules/ecs"
#   name                          = var.name_ecs
#   ecs_cluster_name              = var.ecs_cluster_name
#   common                        = local.common
#   task_cpu                      = var.task_cpu
#   task_ram                      = var.task_ram
#   desired_count                 = var.desired_count
#   internet_cidr_blocks          = var.internet_cidr_blocks
#   max_containers                = var.max_containeres
#   min_containers                = var.min_containeres
#   container_name_ecs            = var.container_name_ecs
#   container_port_ecs            = var.container_port_ecs
#   spring_profile_ecs            = var.spring_profile_ecs
#   tg_arn                        = module.target_group.tg_arn
#   auto_scaling_target_value_cpu = var.auto_scaling_target_value_cpu
#   auto_scaling_target_value_ram = var.auto_scaling_target_value_ram
#   vpc_id                        = local.network["vpc_id"]
#   subnet_ids                    = [data.terraform_remote_state.infrastructure.outputs.public1_subnet, data.terraform_remote_state.infrastructure.outputs.public2_subnet]
#   aws_lb_listener_arn           = module.alb.aws_lb_listener_arn
#   domain_name                   = var.ecs_domain_name
# }

# module "code_pipeline" {
#   source        = "./modules/codebuild-codedeploy-codepipiline/codepipeline"
#   common        = local.common
#   name          = var.name_ecs
#   repo          = var.repo_pipeline
#   branch        = var.branch
#   codebuild_arn = module.codebuild.id_codebuild
#   cluster_name  = module.ecs.cluster_name
#   # git_url = var.git_url
#   # services = var.services
# }

# module "web_cnd" {
#   source      = "./modules/cloudfront"
#   common      = local.common
#   cf_cert_arn = var.cf_cert_arn
#   cdn_domain  = var.cdn_domain
# }

# # Create A record (Alias) for CDN
# module "route_53_cdn" {
#   source                = "./modules/route-53/hostzone-cdn"
#   hosted_zone_public_id = var.hosted_zone_public_id
#   domain                = var.domain
#   cf_s3_domain_name     = module.web_cnd.cf_distribution_domain_name    # Change
#   cf_s3_hosted_zone_id  = module.web_cnd.cf_distribution_hosted_zone_id # Change
# }

# module "alb_waf" {
#   source = "./modules/waf"
#   alb_arn = "arn:aws:elasticloadbalancing:us-east-1:115228050885:loadbalancer/app/test/3b6b75d6f2d78cba"
# }


module "frontend_pipeline" {
  source = "./modules/codebuild-codedeploy-codepipiline/codepipeline-frontend"
  repo = "Trourest186/test_Moon"
  branch = "master"
  name = "frontend"
  common = local.common

}