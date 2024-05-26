variable "endpoint_path" {
  description = "The GET API endpoint path"
  type = string
  default = "visitCount"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function we invoke"
  type = string
}

variable "lambda_invoke_arn" {
  description = "The invoke arn of the Lambda function"
  type = string
}

variable "myregion" {
  type = string
  default = "us-east-1"
}

variable "accountId" {
  type = string
  default = "138984436696"
}
