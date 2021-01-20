terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

locals {
  plan_project_name     = "${var.base_name}-plan"
  apply_project_name    = "${var.base_name}-apply"
  validate_project_name = "${var.base_name}-validate"
}