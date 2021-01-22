terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "random_string" "random" {
  length  = 16
  special = false
}

module "aws-codecommit-repo" {
  source = "../../aws-codecommit-repo"

  repo_name = "aws-repo-${random_string.random.result}"
}