terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.1.6"
}

provider "aws" {
  region = "us-east-2"
}

module "webservice" {
  source = "./module/webservice"

  cluster_name  = "webservers-prod"
  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
}