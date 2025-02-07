FROM chart_data_api_base:latest

WORKDIR /usr/local/src

ADD data/. /usr/local/src

ENV PYTHONPATH=/usr/local/src

CMD ["etl.lambda_handler"]