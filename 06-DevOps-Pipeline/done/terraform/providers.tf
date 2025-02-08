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

  backend "s3" {
  }
}

provider "aws" {
  region = var.AWS_REGION
}
