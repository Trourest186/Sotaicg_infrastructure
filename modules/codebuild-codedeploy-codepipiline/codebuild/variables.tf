variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "name" {
  type = string
}

variable "privileged_mode" {
  type = bool
}

# variable "vpc_id" {
#   type = string
# }

# variable "private_subnet_ids" {
#   type = list
# }

# variable "git_url" {
#   type = string
# }

variable "repo" {
  type = string
}

variable "account" {

}

variable "branch" {
  type = string
}

# variable "buildspec_url" {
#   type = string
# }

# variable "role_codebuild" {
#   type = string
# }

# variable "sg_pipeline" {
#   type = string
# }

# variable "git_token" {
#   type = string
#   default = ""
# }

variable "env_var" {
  type = list(object({
    key   = string
    value = string
  }))
}