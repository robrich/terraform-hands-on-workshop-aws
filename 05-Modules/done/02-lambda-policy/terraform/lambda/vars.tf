variable "function_name" {
  type        = string
  description = "The name of the Lambda resource"
}

variable "description" {
  type        = string
  description = "A friendly description to add to the Lambda resource"
}

variable "handler" {
  type        = string
  description = "The Node function in the zip file to call when running the lambda"
}

variable "zip_filename" {
  type        = string
  description = "The path to the zip file that includes the source code"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables needed by the Node.js function"
}

variable "tags" {
  type        = map(string)
  description = "hardware tags to add to the Lambda"
}

variable "policy_arn" {
  type        = string
  description = "The ARN of the policy to attach to this Lambda's role"
}

variable "runtime" {
  type        = string
  description = "The runtime (language / framework) for the Lambda function, see https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
  default     = "nodejs22.x"
}

variable "memory_size" {
  type        = number
  description = "Megs of memory to allocate to the Lambda"
  default     = 256
}
