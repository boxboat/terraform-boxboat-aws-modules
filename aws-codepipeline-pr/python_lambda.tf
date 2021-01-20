# Zip lambda function - allows python code to be easily edited and saved in source control
data "archive_file" "init" {
  type        = "zip"
  output_path = "${path.module}/lambda/lambda_function.zip"
  source {
    content = templatefile("${path.module}/lambda/lambda_function.py", { build_name = module.codepipeline_terraform_validate_only.project_name })
    filename = "lambda_function.py"
  }
}

# Create lambda function
resource "aws_lambda_function" "trigger_validate_build" {
    filename = "${path.module}/lambda/lambda_function.zip"
    function_name = "trigger-validate-build"
    role = var.lambda_role_arn
    handler = "lambda_function.lambda_handler"
    runtime = var.lambda_runtime //runtime
}

# Sets up trigger for lambda - lets lambda accept input from cloud watch events
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.trigger_validate_build.function_name
  principal      = "events.amazonaws.com"
  source_arn     = aws_cloudwatch_event_rule.event_rule.arn
}

# Create cloud watch event rule - event pattern determines what the rule will trigger on
resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "capture-cloudcommit-repo-change"

  event_pattern = <<EOF
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "${var.codecommit_repo_arn}" 
  ]
}
EOF
}

# Create cloud watch event target - what the event will hit when triggered
resource "aws_cloudwatch_event_target" "event_target" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.trigger_validate_build.arn
}