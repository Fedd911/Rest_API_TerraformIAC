output "table_name" {
  value = aws_dynamodb_table.dynamodb_terraform_table.name
}

output "item_name" {
  value = aws_dynamodb_table_item.VisitCountItem.item
}

output "table_hashkey" {
  value = aws_dynamodb_table.dynamodb_terraform_table.hash_key
}