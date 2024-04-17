# General
variable "project" {
  description = "Sotaicg-dataplatform"
  type = string
}

variable "region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  type = string
  description = "Environment name"
}

variable "account_id" {
  type = string
  description = "Account ID"
}

# Infrastructure
variable "remote_state_bucket" {}

variable "remote_state_key" {}

# ECS
variable "internet_cidr_blocks" {
  
}

variable "ecs_cluster_name" {
  
}

variable "task_cpu" {
  
}

variable "task_ram" {
  
}

variable "tg_arn" {
  
}

variable "desired_count" {
  
}

# ALB
variable "dns_cert_arn" {
  
}

# Target_group
variable "priority" {
  
}

variable "health_check_path" {

}

variable "container_port" {

}

variable "host_header" {

}