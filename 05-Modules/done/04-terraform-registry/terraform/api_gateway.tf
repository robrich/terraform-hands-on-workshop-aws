resource "aws_api_gateway_rest_api" "my_gateway" {

  name        = local.api_gateway_name
  description = "API Gateway for the Terraform workshop"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

resource "aws_api_gateway_deployment" "my_gateway" {
  depends_on = [
    module.api_gateway_route
  ]
  rest_api_id = aws_api_gateway_rest_api.my_gateway.id

  stage_name = "default"

  lifecycle {
    create_before_destroy = true
  }
}

module "api_gateway_route" {
  source = "./api_gateway_route"

  http_method                  = "GET"
  path_part                    = "api"
  lambda_function_name         = module.api_lambda.function_name
  lambda_invoke_arn            = module.api_lambda.lambda_invoke_arn
  lambda_role_name             = module.api_lambda.role_name
  api_gateway_id               = aws_api_gateway_rest_api.my_gateway.id
  api_gateway_root_resource_id = aws_api_gateway_rest_api.my_gateway.root_resource_id
  api_gateway_execution_arn    = aws_api_gateway_rest_api.my_gateway.execution_arn
}
