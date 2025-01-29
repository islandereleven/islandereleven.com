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

def upload_to_s3(df, bucket_name, key='test_data.json', 
               aws_access_key=None, aws_secret_key=None):
    """
    Upload DataFrame to S3 with configurable parameters
    Args:
        df: DataFrame to upload
        bucket_name: Target S3 bucket
        key: S3 object key (default: test_data.json)
        aws_access_key: Optional AWS access key
        aws_secret_key: Optional AWS secret key
    """
    # Get credentials from parameters or environment
    aws_access_key = aws_access_key or os.getenv('AWS_ACCESS_KEY_ID')
    aws_secret_key = aws_secret_key or os.getenv('AWS_SECRET_ACCESS_KEY')
    
    if not all([bucket_name, aws_access_key, aws_secret_key]):
        raise ValueError("Missing required credentials")
    
    # Create session with explicit credentials
    session = boto3.Session(
        aws_access_key_id=aws_access_key,
        aws_secret_access_key=aws_secret_key
    )
    s3 = session.client('s3')
    
    # Convert DataFrame to JSON
    json_buffer = StringIO()
    df.to_json(json_buffer, orient='records')
    json_buffer.seek(0)
    
    # Upload to S3
    s3.put_object(
        Bucket=bucket_name,
        Key=key,
        Body=json_buffer.getvalue()
    )

def main():
    """Main execution with environment variables"""
    bucket_name = os.getenv('S3_BUCKET_NAME')
    if not bucket_name:
        raise ValueError("S3_BUCKET_NAME environment variable required")
    
    df = create_test_data()
    upload_to_s3(df, bucket_name)
    print(f"Uploaded data to s3://{bucket_name}/test_data.json")

if __name__ == "__main__":
    main()