# 1. Tell Terraform which cloud providers we are using
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "azuread" {}
provider "aws" {
  region = "eu-west-2" # London Region
}

