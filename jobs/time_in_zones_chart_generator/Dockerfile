FROM public.ecr.aws/lambda/python:3.10

WORKDIR /var/task

ENV POETRY_VERSION=2.2.1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_NO_INTERACTION=1

RUN pip3 install --no-cache-dir "poetry==$POETRY_VERSION"

COPY pyproject.toml poetry.lock ./
RUN poetry install --only main --no-root --no-ansi

COPY src ./src
RUN poetry install --only main --no-ansi

CMD ["time_in_zones_chart_generator.etl.lambda_handler"]
