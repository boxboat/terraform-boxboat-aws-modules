module "codebuild_project_plan" {
  source = "../aws-codebuild"

  project_name        = local.plan_project_name
  project_description = var.project_description
  codebuild_role_arn  = var.codebuild_role_arn
  git_repo_name       = var.git_repo_name
  git_https_url       = var.git_https_url
  git_branch          = var.git_branch
  buildspec           = templatefile("${path.module}/buildspec.tmpl.plan.yaml", { terraform_version = var.terraform_version })

  tf_plan_name = var.base_name

  tags = var.tags
}
