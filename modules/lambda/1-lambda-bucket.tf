# We use "random_pet" in order to generate a random name for the S3 bucket.
/* resource "random_pet" "lambda_bucket_name" {
    prefix = "lambda"
    length = 2
} */
#It is possible for the function above to generate an invalid S3 bucket name. This will require further regex validation. Bucket to be manually named instead.


# Creating the S3 bucket.
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "terrabucket11111333"
  force_destroy = true
}

#Blocking all public access to the bucket (only the Lambda function will access it in order to store logs)
resource "aws_s3_bucket_public_access_block" "lambda_bucket_pub_access" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}