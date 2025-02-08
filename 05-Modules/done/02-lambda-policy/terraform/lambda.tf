module "api_lambda" {
  source = "./lambda"

  function_name         = local.lambda_name
  description           = "a terraform workshop lambda"
  handler               = local.lambda_handler
  zip_filename          = var.LAMBDA_ZIP_FILE
  environment_variables = local.environment_variables
  tags                  = var.tags
  policy_arn            = module.dynamodb_policy.policy_arn
  # optional:
  # runtime = "nodejs22.x"
  # memory_size = 128
}

module "dynamodb_policy" {
  source = "./dynamodb_policy"

  policy_name  = "${local.lambda_name}-policy"
  dynamodb_arn = aws_dynamodb_table.dynamodb_table.arn
}
