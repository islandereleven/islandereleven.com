import json
import logging

from .pipeline import convert_to_json, process_data, validate_and_filter_df
from .settings import load_settings
from .storage import load_data, write_to_s3


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def lambda_handler(event, context):
    """AWS Lambda handler."""
    settings = load_settings()

    df = load_data(settings.s3_input_path)
    valid_data = validate_and_filter_df(df)
    processed_df = process_data(valid_data)
    json_data = convert_to_json(processed_df)
    write_to_s3(json_data, settings.s3_output_path)

    logger.info("Process completed successfully.")
    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Data processed and uploaded to S3 successfully."}),
    }
