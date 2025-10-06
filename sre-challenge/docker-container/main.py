#!/usr/bin/env python3

from flask import Flask
import os

app = Flask(__name__)
port = int(os.environ.get("PORT", 8080))

@app.route("/")
def hello_world():
    return "Hello, World!"

# healthcheck endpoint
@app.route("/health")
def health_check():
    return "OK", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)
