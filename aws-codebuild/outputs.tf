output "project_name" {
  value       = aws_codebuild_project.codebuild_project.id
  description = "The name of the AWS CodeBuild project created"
}
