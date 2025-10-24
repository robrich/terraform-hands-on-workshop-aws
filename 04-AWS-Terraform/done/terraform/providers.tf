terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.18"
    }
  }

  backend "local" {
  }
}

provider "aws" {
  region = "us-east-1"
}
