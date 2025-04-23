provider "aws" {
  region = var.project_region
}

terraform {
  backend "s3" {
    bucket = "hibp-infra-terraform-state1"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}