import sys
import os
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from awsglue.dynamicframe import DynamicFrame
from pyspark.sql.functions import input_file_name

# Get Glue job arguments
args = getResolvedOptions(sys.argv, ["JOB_NAME", "SOURCE_S3_PATH", "TARGET_S3_PATH"])

# Initialize Glue context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# Define source and target paths
source_s3_path = args["SOURCE_S3_PATH"]
target_s3_path = args["TARGET_S3_PATH"]

# Get list of CSV files from source S3 path
df_files = spark.read.format("csv").option("header", "true").load(source_s3_path)
df_files = df_files.withColumn("file_name", input_file_name())
file_paths = [row["file_name"] for row in df_files.select("file_name").distinct().collect()]

for file_path in file_paths:
    file_name = os.path.basename(file_path).split(".")[0]
    
    # Read each CSV file from S3
    datasource = glueContext.create_dynamic_frame.from_options(
        format_options={"withHeader": True, "separator": ","},
        connection_type="s3",
        format="csv",
        connection_options={"paths": [file_path], "recurse": True}
    )
    
    # Convert DynamicFrame to DataFrame for processing
    df = datasource.toDF()
    
    # Convert back to DynamicFrame
    dynamic_frame = DynamicFrame.fromDF(df, glueContext)
    
    # Define target path based on file name
    file_target_s3_path = os.path.join(target_s3_path, file_name)
    
    # Write the data to S3 in Parquet format with Snappy compression
    glueContext.write_dynamic_frame.from_options(
        frame=dynamic_frame,
        connection_type="s3",
        format="parquet",
        connection_options={"path": file_target_s3_path},
        format_options={"compression": "SNAPPY"}
    )

# Commit the job
# job.commit()
