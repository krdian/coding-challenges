# Docker Container

## Overview

This document explains how to build and run a Docker container for a simple Python web application using Flask.
The application responds with "Hello World" to HTTP requests on port 8080.

Prerequisites
Docker installed on your system

## Build Docker Container

### Project Structure

Ensure your project directory contains:

```text
your-project/
├── Dockerfile
├── requirements.txt
└── app.py
```

### Application code (main.py)

```python
from flask import Flask
import os

app = Flask(__name__)
port = int(os.environ.get("PORT", 8080))

...
```

### Dependencies (requirements.txt)

```text
Flask==2.3.3
```

### Build Command

```bash
docker build -t app:0.0.1 .
```

### Run Docker Container

```bash
docker run -d --name app -p 8080:8080 app:0.0.1
```

### Verification

1. Check running containers:

```bash
docker ps
```

1. Test the application:

```bash
curl http://localhost:8080
```

Expected response: Hello World
