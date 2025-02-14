provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "us-east-1-steppoc"
    region = "us-east-1"
    key = "terraform/glue_etl/terraform.tfstate"
    #dynamodb_table = "terraform_lock_table"
  }
}