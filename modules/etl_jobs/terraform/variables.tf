locals {
  glue_src_path = "${path.root}/../glue_scripts/"
}

variable "s3_bucket" {
  description = "Name of the source s3 bucket"
}