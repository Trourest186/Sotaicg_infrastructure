variable "common" {
  type = object({
    project    = string
    env        = string
    region     = string
    account_id = string
  })
}

# variable "project" {
#   type        = string
#   description = "Project name"
# }

# variable "env" {
#   type        = string
#   description = "Environment name"
# }

variable "cf_cert_arn" {
  type = string
}

variable "cdn_domain" {
  type = string
}