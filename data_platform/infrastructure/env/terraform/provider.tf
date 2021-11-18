terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "robert_polakovic"

    workspaces {
      name = "adastra-demo-infrastructure"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
