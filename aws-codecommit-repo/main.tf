terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}



resource "aws_codecommit_repository" "test" {
  repository_name = var.repo_name
}