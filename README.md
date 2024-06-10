# Phi-3 on CPU

This project provides a small and simple containerized and [quantized Phi-3](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf) backend, making it easy to build, deploy, and run anywhere.

## Overview

This FastAPI server provides a single-threaded API endpoint to generate responses from the Phi-3-mini-4k-instruct model based on prompts sent to the server. It is designed to run inside a Docker container which encapsulates all its dependencies, ensuring a consistent environment for deployment.

## Prerequisites

Before you build and run the Docker container, you need:

- Docker installed on your machine.
- For building the image locally: An authentication token from Hugging Face. You must have an account on [Hugging Face](https://huggingface.co) to obtain this token.

## Installation and Setup

### Option A - Build the Image Locally

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/Phi-3-on-CPU.git
cd Phi-3-on-CPU
```

#### 2. Tune the Model Parameters for Your Machine

In `app.py`, adjust the following parameters:

```python
llm = Llama(
    model_path="./Phi-3-mini-4k-instruct-q4.gguf",
    n_ctx=4096,  # Max context length. Keep shorter for less resource consumption.
    n_threads=8,  # Tune to your CPU threads
    n_gpu_layers=0,  # Number of layers to offload to GPU. Set to 0 if running on CPU. Set to -1 for full GPU inference.
)
```

#### 3. Build the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

```bash
docker build --build-arg HF_AUTH_TOKEN=your_hugging_face_token -t phi-3-on-cpu .
```

Replace `your_hugging_face_token` with your actual Hugging Face authentication token.

### Option B - Pull from Docker Hub

The Docker image for the Phi-3-mini-4k-instruct model is available for public use under the repository `heinous/phi-3-on-cpu`. You can pull the image using the following Docker command:

```bash
docker pull heinous/phi-3-on-cpu:latest
```

This will download the latest version of the phi-3-on-cpu image to your local machine.

### Run the Docker Container

Once the image is available, either built locally or pulled from Docker Hub, you can run the container using:

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

The response will be in JSON format, containing the generated text from the model and the usage details:

```json
{
  "response": "Generated text from the model...",
  "usage": {
    "prompt_tokens": 16,
    "completion_tokens": 349,
    "total_tokens": 365
  }
}
```
This response includes the number of tokens used in the prompt (`prompt_tokens`), the number of tokens in the completion (`completion_tokens`), and the total number of tokens (`total_tokens`).

### Example Using `curl`

```bash
curl -X POST -H "Content-Type: application/json" -d '{"prompt":"How to explain the Internet to a medieval knight?"}' http://localhost:4000/predict
```

## Acknowledgements

- Microsoft Research for developing [Phi-3](https://www.microsoft.com/en-us/research/publication/phi-3-technical-report-a-highly-capable-language-model-locally-on-your-phone/)
- [Hugging Face](https://huggingface.co) for providing the model and tools (see: [Phi-3 on Hugging Face](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf))
- [FastAPI](https://fastapi.tiangolo.com/) for the web framework.
- [Llama Library](https://github.com/yourusername/llama-cpp) for the model integration.

## Responsible AI Considerations

See: [Responsible AI Considerations](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf#responsible-ai-considerations)

Like other language models, the Phi series models can potentially behave in ways that are unfair, unreliable, or offensive. Some of the limiting behaviors to be aware of include:

- Quality of Service: the Phi models are trained primarily on English text. Languages other than English will experience worse performance. English language varieties with less representation in the training data might experience worse performance than standard American English.
Representation of Harms & Perpetuation of Stereotypes: These models can over- or under-represent groups of people, erase representation of some groups, or reinforce demeaning or negative stereotypes. Despite safety post-training, these limitations may still be present due to differing levels of representation of different groups or prevalence of examples of negative stereotypes in training data that reflect real-world patterns and societal biases.
- Inappropriate or Offensive Content: these models may produce other types of inappropriate or offensive content, which may make it inappropriate to deploy for sensitive contexts without additional mitigations that are specific to the use case.
- Information Reliability: Language models can generate nonsensical content or fabricate content that might sound reasonable but is inaccurate or outdated.
- Limited Scope for Code: Majority of Phi-3 training data is based in Python and use common packages such as "typing, math, random, collections, datetime, itertools". If the model generates Python scripts that utilize other packages or scripts in other languages, we strongly recommend users manually verify all API uses.

Developers should apply responsible AI best practices and are responsible for ensuring that a specific use case complies with relevant laws and regulations (e.g. privacy, trade, etc.). Important areas for consideration include:

- Allocation: Models may not be suitable for scenarios that could have consequential impact on legal status or the allocation of resources or life opportunities (ex: housing, employment, credit, etc.) without further assessments and additional debiasing techniques.
- High-Risk Scenarios: Developers should assess suitability of using models in high-risk scenarios where unfair, unreliable or offensive outputs might be extremely costly or lead to harm. This includes providing advice in sensitive or expert domains where accuracy and reliability are critical (ex: legal or health advice). Additional safeguards should be implemented at the application level according to the deployment context.
- Misinformation: Models may produce inaccurate information. Developers should follow transparency best practices and inform end-users they are interacting with an AI system. At the application level, developers can build feedback mechanisms and pipelines to ground responses in use-case specific, contextual information, a technique known as Retrieval Augmented Generation (RAG).
- Generation of Harmful Content: Developers should assess outputs for their context and use available safety classifiers or custom solutions appropriate for their use case.
- Misuse: Other forms of misuse such as fraud, spam, or malware production may be possible, and developers should ensure that their applications do not violate applicable laws and regulations.

## License

The model is licensed under the [MIT license](https://huggingface.co/microsoft/phi-3-mini-128k/resolve/main/LICENSE).

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft’s Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
