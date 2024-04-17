variable "ecs_cluster_name" {
  description = "Ecs cluster name"
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

variable "ecs" {
  type = object({
    role_auto_scaling = string
    role_execution = string
    role_ecs_service = string
    ecs_cluster_id = string
    ecs_cluster_name = string
  })
}

variable "network" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
    sg_container = string
  })
}


variable "name" {
  
}

variable "container_name" {
  
}

variable "ecs" {
  
}

variable "container_port" {
 
}

variable "spring_profile" {
  
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
