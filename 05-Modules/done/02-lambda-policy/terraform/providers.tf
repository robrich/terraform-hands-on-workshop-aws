terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }

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
