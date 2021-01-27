terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }

  backend "s3" {
    bucket = "terraform-states-examples"
    region = "us-east-1"
    key    = "examples/new-codecommit-repo/tf.state"
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