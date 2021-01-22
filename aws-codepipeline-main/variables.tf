variable "base_name" {
  type        = string
  description = "The name of the AWS CodeBuild & CodePipeline project"
}

variable "project_description" {
  type        = string
  description = "The description of the AWS CodeBuild & CodePipeline project"
}

variable "terraform_version" {
  type        = string
  description = "The Terraform version to use"
  default     = "latest"
}

variable "git_repo_name" {
  type        = string
  description = "The name of the AWS CodeCommit repo"
}

variable "git_https_url" {
  type        = string
  description = "The Git URL of the Terraform configuration to build. Use HTTPS."
}

variable "tags" {
  type        = map(string)
  description = "The list of AWS Tags to use when creating the AWS Code Build resources"
}

variable "git_branch" {
  type        = string
  description = "The name of the git branch to use"
  default     = "master"
}

variable "codepipeline_role_arn" {
  type        = string
  description = "The AWS ARN to use for AWS CodePipeline"
}

variable "codebuild_role_arn" {
  type        = string
  description = "The AWS ARN to use for AWS CodeBuild"
}

variable "enable_manual_inspection" {
  type        = bool
  description = "Enable the use of a CodePipeline stage that forces someone to look at the Terraform plan before applying"
}

variable "bucket_name" {
  type = string
}
