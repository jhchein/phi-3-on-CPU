# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory to /app
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Copy the requirements.txt file into the Docker image
COPY requirements.txt .

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . /app

# Switch CWD to /app
WORKDIR /app

# Environment variables
ENV NAME World \
    HUGGINGFACE_HUB_ADD_TOKEN_AS_GIT_CREDENTIAL=false

# Your Hugging Face authentication token needs to be passed as a build argument
ARG HF_AUTH_TOKEN

# Login to Hugging Face
RUN huggingface-cli login --token $HF_AUTH_TOKEN

# Download the Phi-3 model
RUN huggingface-cli download microsoft/Phi-3-mini-4k-instruct-gguf Phi-3-mini-4k-instruct-q4.gguf --local-dir . --local-dir-use-symlinks False

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run app.py with Uvicorn when the container launches
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "5000"]