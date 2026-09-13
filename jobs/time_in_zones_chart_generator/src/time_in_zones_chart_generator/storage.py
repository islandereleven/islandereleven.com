import logging

import boto3
import pandas as pd


logger = logging.getLogger(__name__)


def load_data(s3_path):
    """Load activity data from an S3 Parquet file."""
    try:
        df = pd.read_parquet(s3_path)[["start_date_local", "icu_hr_zones", "icu_hr_zone_times"]]
        logger.info("Data loaded successfully from S3.")
        return df
    except Exception as error:
        logger.error("Error loading data from S3: %s", error)
        raise


def write_to_s3(json_data, s3_output_path):
    """Write chart JSON to an S3 object."""
    try:
        s3_client = boto3.client("s3")
        bucket, key = s3_output_path.replace("s3://", "").split("/", 1)
        s3_client.put_object(Bucket=bucket, Key=key, Body=json_data)
        logger.info("Data written to S3 bucket %s with key %s.", bucket, key)
    except Exception as error:
        logger.error("Error writing data to S3: %s", error)
        raise
