FROM python:3.8.0-alpine3.10

COPY ./requirements.txt .
RUN pip install --no-cache-dir -r ./requirements.txt

WORKDIR /app
COPY ./test_pipeline.py .




