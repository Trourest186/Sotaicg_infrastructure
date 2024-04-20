variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type = string
}

variable "internet_cidr_blocks" {
  
}

variable "common" {
  type = object({
    project = string
    env = string
    region = string
    account_id = string 
  })
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  
}

variable "name" {
  
}

variable "container_name_ecs" {
  
}


variable "container_port_ecs" {
 
}

variable "spring_profile_ecs" {
  
}

variable "task_cpu" {
  
}

variable "task_ram" {
  
}

variable "desired_count" {
  
}

# ALB
## Need check
variable "tg_arn" {
  
}

variable "auto_scaling_target_value_cpu" {
  
}

variable "auto_scaling_target_value_ram" {
  
}

variable "max_containers" {
  
}

variable "min_containers" {
  
}

variable "aws_lb_listener_arn" {
  
}

variable "domain_name" {
  
}