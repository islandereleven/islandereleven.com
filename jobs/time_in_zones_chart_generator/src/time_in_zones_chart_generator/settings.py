import os
from dataclasses import dataclass


DEFAULT_S3_INPUT_PATH = "s3://islandereleven-data-lake/raw/activities/platform=intervals_icu/activities.parquet"
DEFAULT_S3_OUTPUT_PATH = "s3://your-output-bucket/processed/activities.json"


@dataclass(frozen=True)
class JobSettings:
    s3_input_path: str = DEFAULT_S3_INPUT_PATH
    s3_output_path: str = DEFAULT_S3_OUTPUT_PATH


def load_settings(environ=None):
    """Load job settings from environment variables."""
    values = environ or os.environ
    return JobSettings(
        s3_input_path=values.get("S3_INPUT_PATH", DEFAULT_S3_INPUT_PATH),
        s3_output_path=values.get("S3_OUTPUT_PATH", DEFAULT_S3_OUTPUT_PATH),
    )
