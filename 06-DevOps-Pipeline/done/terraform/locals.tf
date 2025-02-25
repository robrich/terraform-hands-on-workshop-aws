locals {
  randomness                 = random_string.workshop_randomness.id
  dynamodb_table_name        = "dynamodb-${var.ENV_NAME}-${local.randomness}"
  lambda_name                = "api-lambda-${var.ENV_NAME}-${local.randomness}"
  lambda_handler             = "app.dynamoDbQueryHandler" // the name of the function in the lambda typescript project
  api_gateway_name           = "api-gateway-${var.ENV_NAME}-${local.randomness}"
  fargate_task_name          = "fargate-task-${var.ENV_NAME}-${local.randomness}"
  fargate_service_name       = "fargate-service-${var.ENV_NAME}-${local.randomness}"
  fargate_container_port     = 3000
  fargate_container_count    = 1
  fargate_cluster_name       = "fargate-cluster-${var.ENV_NAME}-${local.randomness}"
  fargate_log_retention_days = 7
  alb_public_port            = 80
  alb_name                   = "alb-${var.ENV_NAME}-${local.randomness}"
  environment_variables = {
    "DYNAMODB_TABLE" : local.dynamodb_table_name,
    "ENV_NAME" : var.ENV_NAME
    "NODE_PORT" : tostring(local.fargate_container_port)
    "NODE_ENV" : "production"
  }
}
