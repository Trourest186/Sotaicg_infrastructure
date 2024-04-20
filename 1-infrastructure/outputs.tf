# Output for public subnet
output "aws_vpc" {
  value = module.vpc.aws_vpc
}

# output "vpc_cidr_blocks" {
#   value = module.vpc.vpc_cidr_blocks
# }
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

output "private1_subnet" {
  value = module.vpc.private1_subnet
}

output "private2_subnet" {
  value = module.vpc.private2_subnet
}

output "private3_subnet" {
  value = module.vpc.private3_subnet
}

output "public_subnets" {
  value = tolist([module.vpc.public1_subnet, module.vpc.public2_subnet, module.vpc.public3_subnet])
}

output "private_subnets" {
  value = tolist([module.vpc.private1_subnet, module.vpc.private2_subnet, module.vpc.private3_subnet])
}

output "private-routetb" {
  value = module.vpc.aws_route_table_private
}
