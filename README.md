# Phi-3 on CPU

This project provides a small and simple containerized Phi-3 backend, making it easy to build, deploy, and run anywhere.

## Overview

This FastAPI server provides a single-threaded API endpoint to generate responses from the Phi-3-mini-4k-instruct model based on prompts sent to the server. It is designed to run inside a Docker container which encapsulates all its dependencies, ensuring a consistent environment for deployment.

## Prerequisites

Before you build and run the Docker container, you need:

- Docker installed on your machine.
- An authentication token from Hugging Face. You must have an account on [Hugging Face](https://huggingface.co) to obtain this token.

## Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/Phi-3-on-CPU.git
cd Phi-3-on-CPU
```

### 2. (Optional) Tune the Model Parameters for Your Machine

In `app.py`, adjust the following parameters:

```python
llm = Llama(
    model_path="./Phi-3-mini-4k-instruct-q4.gguf",
    n_ctx=4096,  # Max context length. Keep shorter for less resource consumption.
    n_threads=8,  # Tune to your CPU threads
    n_gpu_layers=0,  # Number of layers to offload to GPU. Set to 0 if running on CPU. Set to -1 for full GPU inference.
)
```

### 3. Build the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

```bash
docker build --build-arg HF_AUTH_TOKEN=your_hugging_face_token -t phi-3-on-cpu .
```

Replace `your_hugging_face_token` with your actual Hugging Face authentication token.

### 4. Run the Docker Container

Once the image is built, you can run the container using:

```bash
docker run -p 4000:5000 phi-3-on-cpu
```

This command maps port 5000 inside the container to port 4000 on your host.

## Using the API

The FastAPI server exposes a single POST endpoint at `/predict` which you can use to send prompts to the model.

### Endpoint

- **URL**: `/predict`
- **Method**: POST
- **Content-Type**: application/json

### Request

The request body should contain a JSON object with the `prompt` field:

```json
{
  "prompt": "How to explain the Internet to a medieval knight?"
}
```

### Response

The response will be in JSON format, containing the generated text from the model:

```json
{
  "response": "Generated text from the model..."
}
```

### Example Using `curl`

```bash
curl -X POST -H "Content-Type: application/json" -d '{"prompt":"How to explain the Internet to a medieval knight?"}' http://localhost:4000/predict
```

## Acknowledgements

- Microsoft Research for developing [Phi-3](https://www.microsoft.com/en-us/research/publication/phi-3-technical-report-a-highly-capable-language-model-locally-on-your-phone/)
- [Hugging Face](https://huggingface.co) for providing the model and tools (see: [Phi-3 on Hugging Face](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct))
- [FastAPI](https://fastapi.tiangolo.com/) for the web framework.
- [Llama Library](https://github.com/yourusername/llama-cpp) for the model integration.
