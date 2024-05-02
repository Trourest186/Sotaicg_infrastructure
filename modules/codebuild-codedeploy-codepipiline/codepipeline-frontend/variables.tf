variable "repo" {
  
}

variable "branch" {
  
}


variable "name" {
  
}

variable "common" {
  type = object({
    project    = string
    env        = string
    region     = string
    account_id = string
  })
}