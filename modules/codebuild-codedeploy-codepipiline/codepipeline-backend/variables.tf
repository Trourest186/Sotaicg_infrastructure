variable "common" {
  type = object({
    project    = string
    env        = string
    region     = string
    account_id = string
  })
}

variable "name" {
  type = string
}

# variable "network" {
#   type = object({
#     vpc_id = string
#     subnet_ids = list(string)
#     sg_container = string
#   })
# }

# variable "pipeline" {
#   type = object({
#     # role_codebuild = string
#     role_codepipeline = string
#     role_event_pipeline = string
#     pipeline_bucket = string
#   })
# }

# variable "layers" {
#   type = list(string)
# }

variable "repo" {
  type = string
}

variable "branch" {
  type = string
}

# variable "git_url" {

# }
# variable "secret" {
#   type = string
# }

# variable "source_folder" {
#   type = string
# }

# variable "git_token" {
#   type = string
#   default = ""
# }

# variable "services" {
#   type = list(string)
# }

variable "codebuild_arn" {
  
}

variable "cluster_name" {
  
}