module "vpc" {
  source   = "../modules/vpc"
  project  = var.project
  region   = var.aws_region
  name     = var.name
  vpc_cidr = var.vpc_cidr
  sbit     = var.sbit
}

# ### Create cluster for ECS 
# resource "aws_ecs_cluster" "production-fargate-cluster" {
#   name = "Production-Fargate-Cluster"
# }
