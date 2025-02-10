# tests/unit/test_etl.py
#from app.data.etl import create_test_data, upload_to_s3  # Updated import path
import pytest

def test_imports():
    from app.data import etl  # Adjust this import based on your application's structure
    assert etl is not None