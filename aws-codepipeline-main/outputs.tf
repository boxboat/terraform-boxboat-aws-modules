output "apply_codebuild_project_name" {
  value = module.codebuild_project_validate.project_name
  description = "The name of the AWS CodeBuild project created for the Terraform validation stage."
}