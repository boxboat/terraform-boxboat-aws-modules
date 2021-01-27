resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "codebuild_iam_policy_document" {

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
      "codecommit:GitPull"
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
    sid = "ECRPullPolicy"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ECRAuthPolicy"

    actions = [
      "ecr:GetAuthorizationToken"
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

  statement {
    sid = "Ec2"

    actions = [
      "ec2:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codebuild_iam_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = data.aws_iam_policy_document.codebuild_iam_policy_document.json
}