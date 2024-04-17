variable "common" {
  type = object({
    project = string
    env = string
    region = string
    account_id = string
  })
}

variable "dns_cert_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list
}