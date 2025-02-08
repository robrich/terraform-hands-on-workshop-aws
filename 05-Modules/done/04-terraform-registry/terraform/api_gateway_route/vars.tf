variable "http_method" {
  type        = string
  description = "The public HTTP method for this resource, either GET, POST, PUT, DELETE, HEAD, or OPTIONS"
}
variable "path_part" {
  type        = string
  description = "The URL path after the domain and slash"
}
variable "lambda_function_name" {
  type        = string
  description = "The lambda's function name to invoke"
}
variable "lambda_invoke_arn" {
  type        = string
  description = "The lambda's invoke ARN"
}
variable "lambda_role_name" {
  type        = string
  description = "The lambda's role name"
}

variable "api_gateway_id" {
  type        = string
  description = "The API Gateway ID"
}
variable "api_gateway_root_resource_id" {
  type        = string
  description = "The API Gateway root resource ID"
}
variable "api_gateway_execution_arn" {
  type        = string
  description = "The API Gateway execution ARN"
}
