terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    region         = "us-west-2"
    key            = "terraform.labs.tfstate"
    dynamodb_table = "terraform-state-lock"
  }
  required_version = "~> 0.15.0"
}

provider "random" {
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Name = "Terraform-Labs"
      Environment = "Lab"
    }
  }
}
