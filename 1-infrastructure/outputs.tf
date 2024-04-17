# Output for public subnet
output "aws_vpc" {
  value = module.vpc.aws_vpc
}

output "vpc_cidr_blocks" {
  value = module.vpc.vpc_cidr_blocks
}
# Output for public subnet
output "public1_subnet" {
  value = module.vpc.public1_subnet
}

output "public2_subnet" {
  value = module.vpc.public2_subnet
}

output "public3_subnet" {
  value = module.vpc.public3_subnet
}

output "public_subnets" {
  value = tolist([module.vpc.public1_subnet, module.vpc.public2_subnet, module.vpc.public3_subnet])
}
