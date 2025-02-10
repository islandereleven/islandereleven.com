import pandas as pd
import json
import logging
import os
import boto3
from datetime import datetime, timedelta


# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def load_data(s3_path):
    """Load data from S3 Parquet file."""
    try:
        df = pd.read_parquet(s3_path)[["start_date_local", "icu_hr_zones", "icu_hr_zone_times"]]
        logger.info("Data loaded successfully from S3.")
        return df
    except Exception as e:
        logger.error(f"Error loading data from S3: {e}")
        raise

def validate_and_filter_df(df):
    # Define the function to check if a value is a valid date
    def is_valid_date(date_str):
        try:
            datetime.fromisoformat(date_str)
            return True
        except ValueError:
            return False

    # Define the function to check if a list contains only integers
    def is_list_of_integers(lst):
        return all(isinstance(item, int) for item in lst)

    # Filter the DataFrame
    valid_rows = []
    for index, row in df.iterrows():
        start_date_local = row['start_date_local']
        icu_hr_zones = row['icu_hr_zones']
        icu_hr_zone_times = row['icu_hr_zone_times']

        if (is_valid_date(start_date_local) and
            isinstance(icu_hr_zones, list) and
            isinstance(icu_hr_zone_times, list) and
            is_list_of_integers(icu_hr_zones) and
            is_list_of_integers(icu_hr_zone_times) and
            len(icu_hr_zones) == len(icu_hr_zone_times)):
            valid_rows.append(row)

    # Create a new DataFrame with the valid rows
    valid_df = pd.DataFrame(valid_rows)
    return valid_df


def process_data(df):
    """Process the data to sum heart rate zone times by week, including weeks without data."""
    try:
        # Convert start_date_local to datetime
        df['start_date_local'] = pd.to_datetime(df['start_date_local'])

        # Extract the week number with leading zeros
        df['week'] = df['start_date_local'].dt.isocalendar().year.astype(str) + "-W" + df['start_date_local'].dt.isocalendar().week.apply(lambda x: f'{x:02d}')

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

        # Generate a list of the past 27 weeks up to today with leading zeros
        today = datetime.today()
        past_27_weeks = [(today - timedelta(weeks=i)).isocalendar()[:2] for i in range(27)]
        past_27_weeks = [f"{year}-W{week:02d}" for year, week in past_27_weeks]

        # Ensure all weeks are present in the DataFrame
        for week in past_27_weeks:
            if week not in weekly_sums_df['week'].values:
                weekly_sums_df = pd.concat([weekly_sums_df, pd.DataFrame([[week] + [0]*7], columns=weekly_sums_df.columns)], ignore_index=True)

        # Sort the DataFrame by week
        weekly_sums_df.sort_values('week', inplace=True, ascending=False)
        weekly_sums_df.reset_index(drop=True, inplace=True)

        #logger.info("Data processed successfully.")
        return weekly_sums_df
    except Exception as e:
        #logger.error(f"Error processing data: {e}")
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

    valid_data = validate_and_filter_df(df)
    processed_df = process_data(valid_data)
    json_data = convert_to_json(processed_df)
    write_to_s3(json_data, s3_output_path)

    logger.info("Process completed successfully.")
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Data processed and uploaded to S3 successfully.'})
    }
