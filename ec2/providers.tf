terraform {
  required_providers {
    required_version = ">= 1.0"
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = var.region
  profile = var.aws_profile
}