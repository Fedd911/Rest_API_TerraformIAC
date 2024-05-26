#Creating the REST API
resource "aws_api_gateway_rest_api" "terra_API" {
  name = "TerraGetAPI"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_resource" "API_resource" {
    parent_id = aws_api_gateway_rest_api.terra_API.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.terra_API.id
    path_part = var.endpoint_path
}

#Defining the method that will be used for the API
resource "aws_api_gateway_method" "API_method" {
    authorization = "NONE"
    http_method = "GET"
    resource_id = aws_api_gateway_resource.API_resource.id
    rest_api_id = aws_api_gateway_rest_api.terra_API.id
}

#Integrating the API Gateway with the Lambda
resource "aws_api_gateway_integration" "API_integration" {
    rest_api_id = aws_api_gateway_rest_api.terra_API.id
    resource_id = aws_api_gateway_resource.API_resource.id
    http_method = aws_api_gateway_method.API_method.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = var.lambda_invoke_arn
}    

#Giving permission for the API Gateway to interact with the Lambda code
resource "aws_lambda_permission" "apigw_permission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.terra_API.id}/*/${aws_api_gateway_method.API_method.http_method}${aws_api_gateway_resource.API_resource.path}"
}

resource "aws_api_gateway_deployment" "api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.terra_API.id

    triggers = {
        redeployment = sha1(jsonencode(aws_api_gateway_rest_api.terra_API.body))
    }

    lifecycle {
      create_before_destroy = true
    }
    depends_on = [ aws_api_gateway_method.API_method, aws_api_gateway_integration.API_integration ]
  
}

resource "aws_api_gateway_stage" "api_stage" {
    deployment_id = aws_api_gateway_deployment.api_deployment.id
    rest_api_id = aws_api_gateway_rest_api.terra_API.id
    stage_name = "dev"
}

