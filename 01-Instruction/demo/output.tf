

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.dynamodb_table.arn
}

output "lambda_arn" {
  value = aws_lambda_function.api_lambda.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.api_lambda_role.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.api_lambda.invoke_arn
}

output "environment_variables_for_lambda" {
  value = local.environment_variables
}
