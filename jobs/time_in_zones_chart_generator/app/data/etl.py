import os
import pandas as pd
import boto3
from io import StringIO

def create_test_data():
    """Create test dataframe with configurable data"""
    return pd.DataFrame({
        "id": [1, 2, 3, 4, 5],
        "value": ["apple", "banana", "cherry", "date", "elderberry"]
    })

def lambda_handler(event, context):
    """Lambda handler function"""
    bucket_name = os.getenv('S3_BUCKET_NAME')
    df = create_test_data()
    df.to_parquet('s3://islandereleven-data-lake/oui.parquet')

if __name__ == "__main__":
    lambda_handler(None, None)