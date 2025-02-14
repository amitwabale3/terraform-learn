resource "aws_s3_object" "etl_job_scripts" {
  bucket = var.s3_bucket
  key = "etl_jobs/glue_scripts/csv_to_parquet.py"
  source = "${local.glue_src_path}csv_to_parquet.py"
  etag = filemd5("${local.glue_src_path}csv_to_parquet.py")
}

resource "aws_glue_job" "csv_to_parquet" {
    glue_version = "4.0"
    max_retries = 0
    name = "csv_to_parquet"
    description = "Script to stage the CSV files data in datalake snappy parquet format"
    role_arn = aws_iam_role.glue_execution_service_role.arn
    number_of_workers = 2 #optional, defaults to 5 if not set
    worker_type = "G.1X" #optional
    timeout = "60" #optional
    execution_class = "FLEX" #optional
    command {
        name = "glueetl"
        script_location = "s3://${var.s3_bucket}/etl_jobs/glue_scripts/csv_to_parquet.py"
    }
    default_arguments = {
        "--class"                   = "GlueApp"
        "--enable-job-insights"     = "true"
        "--enable-auto-scaling"     = "false"
        "--enable-glue-datacatalog" = "true"
        "--job-language"            = "python"
        "--job-bookmark-option"     = "job-bookmark-disable"
        "--SOURCE_S3_PATH"    = "s3://us-east-1-steppoc/input/"
        "--TARGET_S3_PATH"    = "s3://us-east-1-steppoc/output/"    
    }
}