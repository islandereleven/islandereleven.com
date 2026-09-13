def test_imports():
    from time_in_zones_chart_generator import etl

    assert etl is not None
    assert etl.lambda_handler is not None
