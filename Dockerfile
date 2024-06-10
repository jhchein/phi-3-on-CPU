# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory to /app
WORKDIR /app

# See https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf for more information on running the Phi-3 model
# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev

# Install Hugging Face CLI, Flask, and the Llama library after model download to ensure dependencies are correctly mapped
RUN pip install llama-cpp-python flask huggingface-hub>=0.17.1

# Your Hugging Face authentication token needs to be passed as a build argument
ARG HF_AUTH_TOKEN

# Disable git credential prompt
ENV HUGGINGFACE_HUB_ADD_TOKEN_AS_GIT_CREDENTIAL=false

# Login to Hugging Face
RUN huggingface-cli login --token $HF_AUTH_TOKEN

# Download the Phi-3 model
RUN huggingface-cli download microsoft/Phi-3-mini-4k-instruct-gguf Phi-3-mini-4k-instruct-q4.gguf --local-dir . --local-dir-use-symlinks False

# Copy the current directory contents into the container at /app
COPY . /app

# Install the Llama library after model download to ensure dependencies are correctly mapped
RUN pip install llama-cpp-python

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]