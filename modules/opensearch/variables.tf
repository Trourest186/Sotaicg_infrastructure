variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "collection_name" {
  default = "sotaicg-collection"
}

variable "vpc_id" {
  
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  
}