variable "subnets" {
 type = list(string) 
}

variable "common" {
  type = object({
    project    = string
    env        = string
    region     = string
    account_id = string
  })
}

variable "kafka_config_revision" {
  
}