terraform {
  backend "s3" {
    bucket = "us-east-1-steppoc"
    region = "us-east-1"
    key = "terraform/terraform.state"
    #dynamodb_table = "terraform_lock_table"
  }
}