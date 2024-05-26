variable "dynamodb_table_name" {
  description = "The name of the table which we use in the Lambda function"
  type        = string
}

variable "dynamodb_item_name" {
  description = "The name of the item we get from the table in order to increment it"
  type        = string
}

variable "dynamodb_table_hashkey" {
  description = "The value of the haskey"
  type        = string
}