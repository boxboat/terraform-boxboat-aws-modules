terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }

  backend "s3" {
    bucket = "facundo-trigger-on-master-backend"
    region = "us-east-1"
    key    = "examples/facundo-trigger-on-master/tf.state"
  }
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

module "codebuild_s3_bucket_pipeline" {
  source = "../../aws-bucket"

  bucket_name = "main-example-pipeline-artifacts"
  tags        = {}
}

module "aws-codebuild-pipeline-on-master" {
  source = "../../aws-codepipeline-main"

  base_name           = "facundo-trigger-on-master"
  project_description = "This project has been auto-generated by a Terraform example"


  terraform_version = "0.13.5"

  git_repo_name = "facundo"
  git_https_url = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/facundo"

  tags = {}

  git_branch = "master"

  codebuild_role_arn    = aws_iam_role.master_codebuild_role.arn
  codepipeline_role_arn = aws_iam_role.master_codepipeline_role.arn

  enable_manual_inspection = true
}