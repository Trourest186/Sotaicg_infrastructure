resource "aws_security_group" "app_security_group" {
  name        = "VPN_endpoints"
  description = "Allow all inbound and outbound traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



  # com.amazonaws.us-east-1.ecr.dkr
  resource "aws_vpc_endpoint" "ecr_dkr" {
    vpc_id       = var.vpc_id
    vpc_endpoint_type = "Interface"
    ip_address_type = "ipv4"
    subnet_ids = var.subnet_ids
    security_group_ids = [aws_security_group.app_security_group.id]
    service_name = "com.amazonaws.us-east-1.ecr.dkr"
  }

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = var.vpc_id
  vpc_endpoint_type = "Interface"
  ip_address_type = "ipv4"
  subnet_ids = var.subnet_ids
  security_group_ids = [aws_security_group.app_security_group.id]
  service_name = "com.amazonaws.us-east-1.ecr.api"
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id       = var.vpc_id
  vpc_endpoint_type = "Interface"
  ip_address_type = "ipv4"
  subnet_ids = var.subnet_ids
  security_group_ids = [aws_security_group.app_security_group.id]
  service_name = "com.amazonaws.us-east-1.logs"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.route_table_id
  service_name = "com.amazonaws.us-east-1.s3"
}