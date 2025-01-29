FROM garmin-puller-base:latest

WORKDIR /usr/local/src

ADD data/. /usr/local/src

ENV PYTHONPATH=/usr/lib/python3/dist-packages:

CMD ["python3", "etl.py"]