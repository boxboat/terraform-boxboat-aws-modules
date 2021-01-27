resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF  
}

data "aws_iam_policy_document" "lambda_iam_policy_document" {

  statement {
    sid = "LambdaPolicy"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "codebuild:StartBuild"
    ]

    resources = ["*"]
  }

}

resource "aws_iam_role_policy" "lambda_iam_policy" {
  role = aws_iam_role.lambda_role.name

  policy = data.aws_iam_policy_document.lambda_iam_policy_document.json
}