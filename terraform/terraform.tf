terraform {
  backend "s3" {
    bucket = "devopsdock-terraform-backend-bucket-07"
    key    = "s3-backend"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.59.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

