locals {
  dynamodb_table_name = "dynamodb-${var.ENV_NAME}"
  lambda_name         = "api-lambda-${var.ENV_NAME}"
  lambda_handler      = "app.dynamoDbQueryHandler"
  environment_variables = {
    "DYNAMODB_TABLE" : local.dynamodb_table_name,
    "ENV_NAME" : var.ENV_NAME
  }
}
