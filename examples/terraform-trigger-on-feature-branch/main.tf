terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }

  backend "s3" {
    bucket = "facundo-trigger-on-develop-backend"
    region = "us-east-1"
    key    = "examples/facundo-trigger-on-feature-branch/tf.state"
  }
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_codecommit_repository" "feature_cicd_test_repo" {
  repository_name = "cicd-pipeline-test-repository"
}

module "aws-codebuild-pipeline-on-feature-branch" {
  source = "../../modules/aws-codepipeline-pr"

  base_name           = "facundo-trigger-on-feature"
  project_description = "This project has been auto-generated by a Terraform example"


  terraform_version = "0.13.5"

  git_repo_name = data.aws_codecommit_repository.feature_cicd_test_repo.repository_name
  git_https_url = data.aws_codecommit_repository.feature_cicd_test_repo.clone_url_http

  tags = {}

  codebuild_role_arn    = aws_iam_role.codebuild_role.arn
  codecommit_repo_arn   = data.aws_codecommit_repository.feature_cicd_test_repo.arn
  lambda_role_arn       = aws_iam_role.lambda_role.arn

  lambda_runtime = "python3.8"

}