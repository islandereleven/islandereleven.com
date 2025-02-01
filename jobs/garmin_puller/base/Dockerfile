FROM public.ecr.aws/lambda/python:3.10 AS base

WORKDIR /usr/local/src

ADD data/. /usr/local/src

# RUN apt-get update

RUN pip3 install -r requirements.txt