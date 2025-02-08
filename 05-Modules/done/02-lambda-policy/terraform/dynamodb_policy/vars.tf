variable "policy_name" {
  type        = string
  description = "The name of the Policy resource"
}

variable "dynamodb_arn" {
  type        = string
  description = "The ARN of the DynamoDB database we'll connect to"
}
