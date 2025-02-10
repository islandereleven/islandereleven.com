import pytest
import os

def test_imports(monkeypatch):
    monkeypatch.setenv("S3_BUCKET_NAME", "test-bucket")
    from app.data import etl  # Adjust this import based on your application's structure
    assert etl is not None