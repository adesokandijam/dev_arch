terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    encrypt = true
    bucket  = "dev-arch-terraform-state"
    key     = "learn-terraform-s3-migrate-tfc/terraform.tfstate"
    region  = "us-west-2"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}