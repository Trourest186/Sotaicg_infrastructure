# General
variable "project" {
  description = "Sotaicg-dataplatform"
  type        = string
}

variable "region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "account_id" {
  type        = string
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

# variable "tg_arn" {

# }

variable "desired_count" {

}


variable "max_containeres" {

}

variable "min_containeres" {

}

variable "container_name_ecs" {
  type = string
}

variable "spring_profile_ecs" {
  type = string
}

variable "auto_scaling_target_value_cpu" {

}

variable "auto_scaling_target_value_ram" {

}

variable "name_ecs" {

}
# ALB
variable "dns_cert_arn" {

}

# Target_group
variable "priority" {

}

variable "health_check_path" {

}

variable "container_port_ecs" {

}

# variable "host_header" {

# }

# Route 53
## ALB
variable "hosted_zone_public_id" {
  type        = string
  description = "Id of Route53 HostedZone public"
}

variable "host_header" {
  type = string
}

## For S3 and CDN
variable "domain" {

}

# ACM
variable "ecs_domain_name" {

}

# Cloudfront
variable "cf_cert_arn" {

}

variable "cdn_domain" {

}


# CI/CD
## Codebuild
variable "name_codebuild" {

}

variable "privileged_mode" {
  type = bool
}

variable "repo" {

}

variable "account" {

}

variable "branch" {

}

variable "env_var" {

}

## Codepipeline
variable "name" {

}

# variable "services" {
  
# }

variable "repo_pipeline" {
  
}