terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.23"
    }
  }

  backend "s3" {
    bucket         = "pgr301-terraform-state"
    key            = "wishifai/tomek/terraform.tfstate"
    region         = "eu-west-1"
  }

  provider "aws" {
    region = "eu-west-1"
  }