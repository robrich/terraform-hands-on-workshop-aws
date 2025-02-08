output "lambda_arn" {
  value = aws_lambda_function.api_lambda.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.api_lambda.invoke_arn
}

output "role_arn" {
  value = aws_iam_role.api_lambda_role.arn
}

output "role_name" {
  value = aws_iam_role.api_lambda_role.name
}

output "function_name" {
  value = var.function_name
}
