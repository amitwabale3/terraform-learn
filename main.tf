provider "aws" {
    region = "us-east-1"
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_value = "ami-0c614dee691cbbf37"
    instance_type_value = "t2.micro"
}

module "dynamo_db_creation" {
    source = "./modules/dynamo_db_creation"
    dynamo_table_name = "terraform_lock"
}

module "s3_creation" {
    source = "./modules/s3_creation"
    bucket_value = "terraform-us-east-1"
}