terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "dybamoDB" {
  source = "./modules/dynamoDB"
}

module "lambda" {
  source                 = "./modules/lambda"
  dynamodb_table_name    = module.dybamoDB.table_name
  dynamodb_item_name     = module.dybamoDB.item_name
  dynamodb_table_hashkey = module.dybamoDB.table_hashkey

}

module "API" {
  source = "./modules/ApiGateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
}