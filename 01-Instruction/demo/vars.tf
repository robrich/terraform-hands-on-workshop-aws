
variable "tags" {
  type    = map(string)
  default = {}
}

variable "ENV_NAME" {
  type        = string
  description = "The environment name: dev, qa, prod, etc"
}

variable "LAMBDA_ZIP_FILE" {
  type        = string
  description = "The zip file containing the lambda function"
}
