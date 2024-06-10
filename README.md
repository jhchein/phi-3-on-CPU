# Phi-3-mini-4k-instruct Model Server

This project contains a Flask application that serves the Phi-3-mini-4k-instruct model using the Llama library. The application is containerized using Docker, making it easy to build, deploy, and run anywhere.

## Overview

This Flask server provides an API endpoint to generate responses from the Phi-3-mini-4k-instruct model based on prompts sent to the server. It is designed to run inside a Docker container which encapsulates all its dependencies.

## Prerequisites

Before you build and run the Docker container, you need:

- Docker installed on your machine.
- An authentication token from Hugging Face. You must have an account on [Hugging Face](https://huggingface.co) to obtain this token.

## Building the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

```bash
docker build --build-arg HF_AUTH_TOKEN=your_hugging_face_token -t my-model-app .
```

Replace `your_hugging_face_token` with your actual Hugging Face authentication token.

## Running the Docker Container

Once the image is built, you can run the container using:

```bash
docker run -p 4000:5000 my-model-app
```

This command maps port 5000 inside the container to port 4000 on your host.

## Using the API

The Flask server exposes a single POST endpoint at /predict which you can use to send prompts to the model. Here's how you can use curl to send a request:

```bash
curl -X POST -H "Content-Type: application/json" -d '{"prompt":"How to explain Internet to a medieval knight?"}' http://localhost:4000/predict
```

## Response Format

The response will be in JSON format, containing the generated text from the model:

```json
{
  "response": "Generated text from the model..."
}
```
