variable "common" {
  type = object({
    project    = string
    env        = string
    region     = string
    account_id = string
  })
}

variable "priority" {
  type = number
}

variable "health_check_path" {
  type = string
}

variable "container_port" {
  type = number
}

# variable "host_header" {
#   type = string
# }

variable "aws_lb_listener_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}