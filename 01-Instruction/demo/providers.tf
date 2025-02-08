terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83"
    }
  }

  backend "local" {
  }
}

provider "aws" {
  region = "us-east-1"
}
