variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Sotaicg-data-platform"
  type        = string
}

variable "name" {}

variable "vpc_cidr" {}

variable "sbit" {}