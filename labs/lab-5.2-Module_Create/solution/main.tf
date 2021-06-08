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
  region = local.region
  default_tags {
    tags = merge(var.tags,{
      Name = "Terraform-Labs"
      Environment = local.environment
    })
  }
}

locals {
  region = var.region
  environment = "Lab"
  instance_ami = "ami-03d5c68bab01f3496"  # ubuntu OS
  size_spec = {
    low = {
      cluster_size = 1
    },
    medium = {
      cluster_size = 2
    },
    high = {
      cluster_size = 3
    }
  }
  cluster_size = try(coalesce(var.node_count, lookup(local.size_spec,var.load_level).cluster_size), 1)
  archiving_enabled = false
}
