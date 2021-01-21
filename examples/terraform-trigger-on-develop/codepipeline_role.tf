resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "codepipeline_iam_policy_document" {

  statement {
    sid = "CloudWatchLogsPolicy"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  statement {
    sid = "CodeCommitPolicy"

    actions = [
      "codecommit:Get*",
      "codecommit:UploadArchive"
    ]

    resources = ["*"]
  }

  statement {
    sid = "CodeBuildPolicy"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = ["*"]
  }

  statement {
    sid = "S3GetObjectPolicy"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = ["*"]
  }

  statement {
    sid = "S3PutObjectPolicy"

    actions = [
      "s3:PutObject"
    ]

    resources = ["*"]
  }

  statement {
    sid = "S3BucketIdentity"

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_iam_policy" {
  role = aws_iam_role.codepipeline_role.name

  policy = data.aws_iam_policy_document.codepipeline_iam_policy_document.json
}