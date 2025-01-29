FROM python:3.10

WORKDIR /usr/local/src

ADD data/. /usr/local/src

ENV PYTHONPATH=/usr/lib/python3/dist-packages:

RUN apt-get update

RUN pip3 install -r requirements.txt