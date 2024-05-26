output "lambda_function_name" {
  value = aws_lambda_function.lambda_function_terra.function_name
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda_function_terra.invoke_arn
}