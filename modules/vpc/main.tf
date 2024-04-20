# Create VPC
resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project}-vpc"
    Project = "${var.name}"
  }
}

# To Fetch Availability Zones for creation of subnets
data "aws_availability_zones" "available" {
  state = "available"
}

# Create internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-igw"
    Project = "${var.name}"
  }
}

# VPC architecture include 2 public, 1 private subnet

# Create public subnet 1
resource "aws_subnet" "pub1" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 0)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-pub1"
    Project = "${var.name}"
  }
}

# Create public subnet 2
resource "aws_subnet" "pub2" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 1)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-pub2"
    Project = "${var.name}"
  }
}

# Create public subnet 3
resource "aws_subnet" "pub3" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 2)
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-pub2"
    Project = "${var.name}"
  }
}

# Create private subnet 1
resource "aws_subnet" "priv1" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 3)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-priv1"
    Project = "${var.name}"
  }
}

resource "aws_subnet" "priv2" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 4)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-priv2"
    Project = "${var.name}"
  }
}

resource "aws_subnet" "priv3" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 5)
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-priv3"
    Project = "${var.name}"
  }
}

# resource "aws_subnet" "priv2" {
#   vpc_id = aws_vpc.vpc.id

#   cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 2)
#   availability_zone       = data.aws_availability_zones.available.names[1]
#   map_public_ip_on_launch = true

#   tags = {
#     Name    = "${var.project}-priv2"
#     Project = "${var.name}"
#   }
# }

# resource "aws_subnet" "priv3" {
#   vpc_id = aws_vpc.vpc.id

#   cidr_block              = cidrsubnet(var.vpc_cidr, var.sbit, 3)
#   availability_zone       = data.aws_availability_zones.available.names[2]
#   map_public_ip_on_launch = true

#   tags = {
#     Name    = "${var.project}-priv3"
#     Project = "${var.name}"
#   }
# }
# # Create Elastic IP for Nat Gatway
# resource "aws_eip" "eip" {
#   vpc      = true
#   tags     = {
#     Name = "${var.project}-eip"
#     Project  = "${var.name}"
#   }
# }

# Attaching Elastic IP to NAT gateway, deployed at public1 subnet
# resource "aws_nat_gateway" "ngw" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.pub1.id
#   tags = {
#     Name = "${var.project}-ngw"
#     Project  = "${var.name}"
#   }
# }

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "${var.project}-public-rtb"
    Project = "${var.name}"
  }
}

# Create private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-private-rtb"
    Project  = "${var.name}"
  }
}

# Create Public Route Table Association
resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub3" {
  subnet_id      = aws_subnet.pub3.id
  route_table_id = aws_route_table.public.id
}

#Create Private Route Table Association
resource "aws_route_table_association" "priv1" {
  subnet_id      = aws_subnet.priv1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "priv2" {
  subnet_id      = aws_subnet.priv2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "priv3" {
  subnet_id      = aws_subnet.priv3.id
  route_table_id = aws_route_table.private.id
}


