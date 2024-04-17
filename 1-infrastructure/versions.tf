provider "aws" {
  region  = var.aws_region
  profile = "Adminstator-use1-115228050885"
}

# Save state file into S3 bucket
terraform {
  backend "s3" {}
}