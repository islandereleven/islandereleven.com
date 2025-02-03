import os
import requests
from datetime import datetime, timedelta
import pandas as pd
import logging
import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
import json
# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def get_api_key_from_secrets_manager(secret_name, region_name):
    """Retrieve the API key from AWS Secrets Manager."""
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except (NoCredentialsError, PartialCredentialsError) as e:
        logger.error(f"Credentials error: {e}")
        raise
    except client.exceptions.DecryptionFailureException:
        logger.error("Secrets Manager can't decrypt the protected secret text using the provided KMS key.")
        raise
    except client.exceptions.InternalServiceErrorException:
        logger.error("An error occurred on the server side.")
        raise
    except client.exceptions.InvalidParameterException:
        logger.error("You provided an invalid value for a parameter.")
        raise
    except client.exceptions.InvalidRequestException:
        logger.error("You provided a parameter value that is not valid for the current state of the resource.")
        raise
    except client.exceptions.ResourceNotFoundException:
        logger.error("We can't find the resource that you asked for.")
        raise

    secret = get_secret_value_response['SecretString']
    secret_dict = json.loads(secret)
    return secret_dict.get('intervals_icu_api_key')

def calculate_date_range():
    """Calculate the date range for the last 27 weeks."""
    today = datetime.today()
    twenty_seven_weeks_ago = today - timedelta(weeks=27)
    oldest = twenty_seven_weeks_ago.strftime('%Y-%m-%d')
    newest = today.strftime('%Y-%m-%d')
    return oldest, newest

def fetch_activities(api_key, oldest, newest):
    """Fetch activities from the Intervals.icu API."""
    url = "https://intervals.icu/api/v1/athlete/0/activities"
    params = {
        'oldest': oldest,
        'newest': newest
    }
    auth = ('API_KEY', api_key)

    try:
        response = requests.get(url, auth=auth, params=params)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        logger.error(f"Request failed: {e}")
        return None

def save_activities_to_parquet(activities):
    """Save the fetched activities to a Parquet file."""
    if activities:
        df = pd.DataFrame(activities)
        df.to_parquet("s3://islandereleven-data-lake/raw/activities/platform=intervals_icu/activities.parquet")
        logger.info(f"Saved {len(activities)} activities to Parquet file.")
    else:
        logger.warning("No activities to save.")

def lambda_handler(event, context):
    """Lambda function handler."""
    secret_name = os.getenv('SECRET_NAME', '')
    region_name = os.getenv('AWS_REGION', 'eu-central-1')

    try:
        api_key = get_api_key_from_secrets_manager(secret_name, region_name)
        oldest, newest = calculate_date_range()
        activities = fetch_activities(api_key, oldest, newest)
        save_activities_to_parquet(activities)
    except Exception as e:
        logger.error(f"Error in lambda_handler: {e}")

if __name__ == "__main__":
    lambda_handler(None, None)
