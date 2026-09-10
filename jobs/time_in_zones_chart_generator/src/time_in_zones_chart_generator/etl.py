"""Compatibility entry point for the Lambda runtime."""

from .handler import lambda_handler
from .pipeline import convert_to_json, process_data, validate_and_filter_df
from .storage import load_data, write_to_s3

__all__ = [
    "convert_to_json",
    "lambda_handler",
    "load_data",
    "process_data",
    "validate_and_filter_df",
    "write_to_s3",
]
