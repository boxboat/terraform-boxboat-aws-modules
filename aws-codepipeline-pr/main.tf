terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

locals {
  validate_project_name = "${var.base_name}-validate"
}