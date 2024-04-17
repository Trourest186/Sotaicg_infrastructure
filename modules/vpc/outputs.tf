
# output "aws_eip" {
#   value = aws_eip.eip.public_ip
# }

output "aws_vpc" {
  value = aws_vpc.vpc.id
}

output "aws_internet_gateway" {
  value = aws_internet_gateway.igw.id
}

# output "aws_nat_gateway" {
#   value = aws_nat_gateway.nat.id
# }

output "aws_route_table_public" {
  value = aws_route_table.public.id
}

# output "aws_route_table_private" {
#   value = aws_route_table.private.id
# }

output "aws_route_table_bastion" {
  value = aws_security_group.bastion.id
}

output "aws_instance_table_webserver" {
  value = aws_security_group.webserver.id
}

output "aws_instance_table_dbserver" {
  value = aws_security_group.dbserver.id
}

# Output for public subnet
output "public1_subnet" {
  value = aws_subnet.pub1.id
}

output "public2_subnet" {
  value = aws_subnet.pub1.id
}

output "public3_subnet" {
  value = aws_subnet.pub1.id
}

# Output for private_subnet
output "private1_subnet" {
  value = aws_subnet.priv1.id
}

output "private2_subnet" {
  value = aws_subnet.priv2.id
}

output "private3_subnet" {
  value = aws_subnet.priv3.id
}