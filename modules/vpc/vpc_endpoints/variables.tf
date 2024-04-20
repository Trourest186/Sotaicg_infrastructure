variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "route_table_id" {
  type = list(string)
}