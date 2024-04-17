terraform {
  backend "s3" {
    bucket = "terraform-sotaicg"
    key = "terraform.tfstate"
    region = "us-east-1"
    profile = "Adminstator-use1-115228050885" # Change
  }
}