FROM python:3.13-slim AS builder

WORKDIR /layer

# Install zip, clean build tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY layer/requirements.txt .

# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt

RUN pip install --no-cache-dir --only-binary=:all: \
    --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org \
    -r requirements.txt \
    # Remove unnecessary files
    && find python -type d -name "__pycache__" -exec rm -rf {} + \
    && find python -type d -name "*.dist-info" -exec rm -rf {} + \
    && find python -type d -name "*.egg-info" -exec rm -rf {} + \
    && find /usr/local/lib/python3.13/site-packages -type d -name "tests" -exec rm -rf {} + \
    && find /usr/local/lib/python3.13/site-packages -type d -name "__pycache__" -exec rm -rf {} + \
    && find python -type f -name "*.pyo" -delete \
    && find python -type f -name "*.pyc" -delete \
    && rm -rf python/pandas/tests || true \
    && rm -rf python/pandas/docs
    
EXPOSE 3317
# Zip for Lambda Layer
# RUN zip -r9 /layer.zip python
