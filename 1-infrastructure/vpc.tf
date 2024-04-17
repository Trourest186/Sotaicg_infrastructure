module "vpc" {
  source   = "../modules/vpc"
  project  = var.project
  region   = var.aws_region
  name     = var.name
  vpc_cidr = var.vpc_cidr
  sbit     = var.sbit
}
