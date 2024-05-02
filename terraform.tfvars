# General
# region = us-east-1

# Local
project    = "sotaicg-platform"
env        = "test"
account_id = "115228050885"

## Key for S3
remote_state_key    = "layer1/infrastructure.tfstate"
remote_state_bucket = "trourest-s3"

# ACM
ecs_domain_name = "trourest186.online"
dns_cert_arn    = "arn:aws:acm:us-east-1:115228050885:certificate/bd28ef8c-a3e2-40f5-9b9c-8f1e5c8d8284"
cf_cert_arn     = "arn:aws:acm:us-east-1:115228050885:certificate/bd28ef8c-a3e2-40f5-9b9c-8f1e5c8d8284"
# alt_name    = ["*.www.trourest186.online"]


# Using for ECS
internet_cidr_blocks          = "0.0.0.0/0"
ecs_cluster_name              = "Production-ECS-Cluster"
task_cpu                      = 512
task_ram                      = 1024
auto_scaling_target_value_cpu = 512
auto_scaling_target_value_ram = 1024
desired_count                 = 2
max_containeres               = 2
min_containeres               = 1
container_name_ecs            = "backend-dataplatform"
container_port_ecs            = 8080 # Change
spring_profile_ecs            = "test"
name_ecs                      = "backend_dataplatform"
# Using for alb

# Using target group
priority          = 80
health_check_path = "/"


# Using for route53
## ALB
hosted_zone_public_id = "Z029887812KRQEVI3ULX3"
host_header           = "www.trourest186.online"

## CDN
domain     = "cdn.trourest186.online"
cdn_domain = "cdn.trourest186.online"


# CI/CD
## Codebuild
name_codebuild  = "cicd-sotaicg"
privileged_mode = true
repo            = "test_Moon"
account         = "Trourest186"
branch          = "master"
env_var = [
  {
    key   = "test"
    value = "value1"
  },
]

## Codepipeline
repo_pipeline = "Trourest186/test_Moon"
name = "sotaicg" # name
# services = [
#   {

#   },
# ]