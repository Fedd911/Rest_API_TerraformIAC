# Creates a DynamoDB table

resource "aws_dynamodb_table" "dynamodb_terraform_table" {
  name         = "VisitCountIAC"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Name        = "Demo DynamoDB Table"
    Environment = "Testing"
  }

}

# Add an item to the DynamoDB table 
# We use the "Value" in order to keep track of the visitor count to our website

resource "aws_dynamodb_table_item" "VisitCountItem" {
  depends_on = [
    aws_dynamodb_table.dynamodb_terraform_table
  ]

  table_name = aws_dynamodb_table.dynamodb_terraform_table.name
  hash_key   = aws_dynamodb_table.dynamodb_terraform_table.hash_key

  item = <<ITEM
{
  "ID": {"S": "TotalVisitCount"},
  "Value": {"N": "1"}
}
ITEM
}