resource "aws_lambda_function" "api_lambda" {

  function_name = var.function_name
  description   = var.description

  handler  = var.handler
  filename = var.zip_filename

  runtime = var.runtime

  role = aws_iam_role.api_lambda_role.arn

  environment {
    variables = var.environment_variables
  }

  memory_size = var.memory_size
  timeout     = 29 // API Gateway times out at 30 seconds

  tags = var.tags
}

# the role to run the lambda
resource "aws_iam_role" "api_lambda_role" {
  name               = "${var.function_name}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# connect role and policy
resource "aws_iam_role_policy_attachment" "api_lambda_policy_attachment" {
  role       = aws_iam_role.api_lambda_role.name
  policy_arn = var.policy_arn
}
