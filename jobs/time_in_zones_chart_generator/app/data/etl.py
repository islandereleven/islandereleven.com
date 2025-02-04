import pandas as pd
import json
import logging
import os
import boto3

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def load_data(s3_path):
    """Load data from S3 Parquet file."""
    try:
        df = pd.read_parquet(s3_path)
        logger.info("Data loaded successfully from S3.")
        return df
    except Exception as e:
        logger.error(f"Error loading data from S3: {e}")
        raise

def process_data(df):
    """Process the data to sum heart rate zone times by week."""
    try:
        # Convert start_date_local to datetime
        df['start_date_local'] = pd.to_datetime(df['start_date_local'])

        # Extract the week number
        df['week'] = df['start_date_local'].dt.isocalendar().year.apply(str) + "-W" + df['start_date_local'].dt.isocalendar().week.apply(str)

        # Initialize a dictionary to store the summed times for each week
        weekly_sums = {}

        # Iterate over each row in the DataFrame
        for index, row in df.iterrows():
            week = row['week']
            hr_zones = row['icu_hr_zones']
            hr_zone_times = row['icu_hr_zone_times']

            if week not in weekly_sums:
                weekly_sums[week] = [0] * len(hr_zones)

            for i in range(len(hr_zones)):
                weekly_sums[week][i] += hr_zone_times[i]

        # Convert the dictionary to a DataFrame
        weekly_sums_df = pd.DataFrame.from_dict(weekly_sums, orient='index', columns=[f'zone_{i}' for i in range(1, 8)])

        # Reset index to have the week number as a column
        weekly_sums_df.reset_index(inplace=True)
        weekly_sums_df.rename(columns={'index': 'week'}, inplace=True)

        # Get the unique heart rate zones
        unique_hr_zones = df['icu_hr_zones'].iloc[0]

        # Rename columns to include the max heart rate of each zone
        weekly_sums_df.columns = ['week'] + [f'Zone {i} (Max HR: {hr}bpm)' for i, hr in enumerate(unique_hr_zones, start=1)]

        logger.info("Data processed successfully.")
        return weekly_sums_df
    except Exception as e:
        logger.error(f"Error processing data: {e}")
        raise

def convert_to_json(df):
    """Convert the DataFrame to a JSON string."""
    try:
        json_data = df.to_json(orient='records')
        logger.info("Data converted to JSON successfully.")
        return json_data
    except Exception as e:
        logger.error(f"Error converting data to JSON: {e}")
        raise

def write_to_s3(json_data, s3_output_path):
    """Write the JSON data to an S3 bucket."""
    try:
        s3_client = boto3.client('s3')
        bucket, key = s3_output_path.replace('s3://', '').split('/', 1)
        s3_client.put_object(Bucket=bucket, Key=key, Body=json_data)
        logger.info(f"Data written to S3 bucket {bucket} with key {key}.")
    except Exception as e:
        logger.error(f"Error writing data to S3: {e}")
        raise

def lambda_handler(event, context):
    """AWS Lambda handler."""
    s3_input_path = os.getenv('S3_INPUT_PATH', 's3://islandereleven-data-lake/raw/activities/platform=intervals_icu/activities.parquet')
    s3_output_path = os.getenv('S3_OUTPUT_PATH', 's3://your-output-bucket/processed/activities.json')

    df = load_data(s3_input_path)
    processed_df = process_data(df)
    json_data = convert_to_json(processed_df)
    write_to_s3(json_data, s3_output_path)

    logger.info("Process completed successfully.")
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Data processed and uploaded to S3 successfully.'})
    }
