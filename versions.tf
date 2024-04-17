# Version for terraform, aws provider
terraform {
  required_version = ">= 1.4.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
  }
}

# Provider-1 for us-east-1 (Default Provider)
provider "aws" {}

# Provider-2 for us-west-1
provider "aws" {
  region  = "ap-east-1"
  profile = "default"
  alias   = "aws-ap-east-1"
}