variable "common" {
  type = object({
    project    = string
    env        = string
    region     = string
    account_id = string
  })
}

variable "documentdb_name" {
  
}

variable "docdb_instance_class" {
  
}

variable "docdb_password" {
  
}

variable "vpc_id" {
  
}