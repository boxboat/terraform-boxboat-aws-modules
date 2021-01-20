resource "aws_codebuild_project" "codebuild_project" {
  name          = var.project_name
  description   = var.project_description
  build_timeout = "5"
  service_role  = var.codebuild_role_arn
  badge_enabled = true

  source_version = "refs/heads/${var.git_branch}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = local.environment_variables

      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-terraform-builds"
      stream_name = "log-${var.project_name}"
    }
  }

  source {
    type     = "CODECOMMIT"
    location = var.git_https_url

    buildspec = var.buildspec
  }

  tags = var.tags
}
