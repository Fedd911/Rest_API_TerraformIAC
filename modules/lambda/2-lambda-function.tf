# Storing the JSON for the IAM role as a variable
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

}

#Creating the IAM Role using the variable policy above
resource "aws_iam_role" "lambda_role" {

  name               = "iam_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

#Attaching CloudWatch policy to the role
resource "aws_iam_role_policy_attachment" "cloud_watch_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Attaching DynamoDB policy to the role
resource "aws_iam_role_policy_attachment" "lambda_dynamoDB_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

#Attaching S3 policy to the role
resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#Creating the lambda function from the .zip file in the S3 bucket
resource "aws_lambda_function" "lambda_function_terra" {
  function_name = "visitFunctionTerraform"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_visitCount.key

  runtime = "python3.8"
  handler = "function.lambda_handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      DYNAMODB_TABLE_NAME    = var.dynamodb_table_name
      DYNAMODB_ITEM_NAME     = var.dynamodb_item_name
      DYNAMODB_TABLE_HASHKEY = var.dynamodb_table_hashkey
    }
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_group" {
  name = "/aws/lambda/terraformLambda"

  retention_in_days = 7
}


#Archiving the python code so it can be uploaded to S3 later on 
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./modules/lambda/function.py"
  output_path = "./modules/lambda/lambda_function.zip"
}

#Uploading the archive into S3 bucket
resource "aws_s3_object" "lambda_visitCount" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path

  etag = filemd5(data.archive_file.lambda_zip.output_path)
}

