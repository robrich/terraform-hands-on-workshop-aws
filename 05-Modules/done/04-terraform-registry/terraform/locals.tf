locals {
  randomness          = random_string.workshop_randomness.id
  dynamodb_table_name = "dynamodb-${var.ENV_NAME}-${local.randomness}"
  lambda_name         = "api-lambda-${var.ENV_NAME}-${local.randomness}"
  lambda_handler      = "app.dynamoDbQueryHandler" // the name of the function in the lambda typescript project
  api_gateway_name    = "api-gateway-${var.ENV_NAME}-${local.randomness}"
  environment_variables = {
    "DYNAMODB_TABLE" : local.dynamodb_table_name,
    "ENV_NAME" : var.ENV_NAME
  }
}
