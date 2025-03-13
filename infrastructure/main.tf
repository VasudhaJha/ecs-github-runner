terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "self-hosted-github-runner-terraform-state"
    dynamodb_table = "self-hosted-github-runner-terraform-state-lock"
    key = "terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}