module "codebuild_s3_bucket_pipeline" {
  source = "../aws-bucket"

  bucket_name = "${var.base_name}-pipeline-artifacts"
  tags        = var.tags
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.base_name}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = module.codebuild_s3_bucket_pipeline.bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = var.git_repo_name
        BranchName           = var.git_branch
        PollForSourceChanges = true
      }
    }
  }

  stage {
    name = "Validate"

    action {
      name             = "Validate"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["terraform_validate"]

      configuration = {
        ProjectName = local.validate_project_name
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["terraform_plan"]

      configuration = {
        ProjectName = local.plan_project_name
      }
    }
  }

  dynamic "stage" {

    for_each = var.enable_manual_inspection ? ["1"] : []

    content {
      name = "Manual_Inspection"

      action {
        name     = "Manual_Inspection"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          "CustomData" : "Could you take a look at the Terraform plan by looking at the Plan stage build output?"
        }
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name     = "Apply"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "source_output",
        "terraform_plan"
      ]
      version = "1"

      configuration = {
        ProjectName   = local.apply_project_name
        PrimarySource = "source_output"
      }
    }
  }
}
