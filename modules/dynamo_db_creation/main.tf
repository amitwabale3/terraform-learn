provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "table_details" {
  name = var.dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}