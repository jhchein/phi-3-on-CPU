# Phi-3-on-CPU Model Server

This project contains a FastAPI application that serves the Phi-3-mini-4k-instruct model using the Llama library. The application is containerized using Docker, making it easy to build, deploy, and run anywhere.

## Overview

This FastAPI server provides an API endpoint to generate responses from the Phi-3-mini-4k-instruct model based on prompts sent to the server. It is designed to run inside a Docker container which encapsulates all its dependencies, ensuring a consistent environment for deployment.

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

### 2. Build the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

```bash
docker build --build-arg HF_AUTH_TOKEN=your_hugging_face_token -t phi-3-on-cpu .
```

Replace `your_hugging_face_token` with your actual Hugging Face authentication token.

### 3. Run the Docker Container

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

## Development and Testing

### Running Locally

If you prefer to run the application locally without Docker, make sure you have Python 3.11 installed. Then follow these steps:

1. **Install dependencies**:

```bash
pip install -r requirements.txt
```

2. **Run the FastAPI application**:

```bash
uvicorn app:app --host 0.0.0.0 --port 5000
```

### Testing the Endpoint

You can use tools like Postman or `curl` to test the endpoint locally as described in the previous sections.

## Logging

The application uses Python's built-in `logging` module to log important information, such as received prompts and model outputs. This can be useful for monitoring and debugging purposes.

## Security Considerations

- **API Token**: Make sure to keep your Hugging Face API token secure. Do not hardcode it in your source files or expose it in public repositories.
- **Docker Security**: Follow best practices for securing Docker containers, such as running the container with a non-root user and limiting the container's permissions.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Hugging Face](https://huggingface.co) for providing the model and tools.
- [FastAPI](https://fastapi.tiangolo.com/) for the web framework.
- [Llama Library](https://github.com/yourusername/llama-cpp) for the model integration.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any improvements or bug fixes.

## Contact

For any questions or inquiries, please contact [yourname](mailto:youremail@example.com).
