FROM python:3.9

WORKDIR /analysis

COPY . ./

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV DB_NAME=aoty \
    DB_USER=user \
    DB_PASSWORD=password \
    DB_HOST=db \
    DB_PORT=5432 \
    NUM_QUERIES=5


CMD ["python", "source.py"]
