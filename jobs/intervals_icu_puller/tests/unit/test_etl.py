# tests/unit/test_etl.py
from app.data.etl import create_test_data, upload_to_s3  # Updated import path
from moto import mock_aws
import pytest
import boto3

@pytest.fixture
def s3_client():
    with mock_aws():  # Changed to mock_aws
        yield boto3.client('s3', region_name='us-east-1')

def test_create_test_data():
    df = create_test_data()
    assert len(df) == 5
    assert list(df.columns) == ['id', 'value']

def test_upload_to_s3(s3_client):
    # Setup test bucket
    test_bucket = 'test-bucket'
    s3_client.create_bucket(Bucket=test_bucket)
    
    # Test data
    df = create_test_data()
    
    # Call function
    upload_to_s3(
        df=df,
        bucket_name=test_bucket,
        aws_access_key='test-key',
        aws_secret_key='test-secret'
    )
    
    # Verify upload
    response = s3_client.list_objects(Bucket=test_bucket)
    assert 'Contents' in response
    assert len(response['Contents']) == 1
    assert response['Contents'][0]['Key'] == 'test_data.json'