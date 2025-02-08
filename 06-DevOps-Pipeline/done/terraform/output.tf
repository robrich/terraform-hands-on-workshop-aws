
output "randomness" {
  value = local.randomness
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.name
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

output "my_gateway_arn" {
  value = aws_api_gateway_rest_api.my_gateway.arn
}

output "my_gateway_url" {
  value = "${aws_api_gateway_deployment.my_gateway.invoke_url}/${aws_api_gateway_resource.root.path_part}"
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-call-api.html
}

output "environment_variables_for_lambda" {
  value = local.environment_variables
}

output "environment_variables_for_fargate" {
  value = [for key, value in local.environment_variables : { "name" = key, "value" = value }]
}

output "fargate_task_arn" {
  value = aws_ecs_task_definition.fargate_task.arn
}

output "fargate_task_role_arn" {
  value = aws_iam_role.fargate_role.arn
}

output "fargate_service_arn" {
  value = aws_ecs_service.fargate_service.id
}

output "fargate_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "alb_arn" {
  value = aws_alb.alb.arn
}

output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}

output "alb_url" {
  value = "http://${aws_alb.alb.dns_name}/api/"
}
