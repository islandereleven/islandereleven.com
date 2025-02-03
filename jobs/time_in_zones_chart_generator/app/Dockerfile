FROM garmin-puller-base:latest

WORKDIR /usr/local/src

ADD data/. /usr/local/src

ENV PYTHONPATH=/usr/local/src

CMD ["etl.lambda_handler"]