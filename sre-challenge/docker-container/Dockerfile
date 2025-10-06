FROM python:3.9.23-alpine3.22

WORKDIR /app

COPY main.py .

COPY requirements.txt .

RUN apk update && apk upgrade --no-cache && \
	pip install --upgrade pip && \
	pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["python", "main.py"]