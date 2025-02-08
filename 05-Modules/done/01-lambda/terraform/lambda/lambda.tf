resource "aws_lambda_function" "api_lambda" {

  function_name = var.function_name
  description   = var.description

  handler  = var.handler
  filename = var.zip_filename

  runtime = "nodejs22.x"

  role = aws_iam_role.api_lambda_role.arn

  environment {
    variables = var.environment_variables
  }

  memory_size = 256
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

# policy allows reading and writing to dynamodb and logs
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/iam-policy-example-data-crud.html
resource "aws_iam_policy" "api_lambda_policy" {
  name   = "${var.function_name}-policy"
  path   = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },{
      "Sid": "DynamoDBTableAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:ConditionCheckItem",
        "dynamodb:PutItem",
        "dynamodb:DescribeTable",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Resource": "${var.dynamodb_arn}"
    }
  ]
}
EOF
}

# connect role and policy
resource "aws_iam_role_policy_attachment" "api_lambda_policy_attachment" {
  role       = aws_iam_role.api_lambda_role.name
  policy_arn = aws_iam_policy.api_lambda_policy.arn
}
