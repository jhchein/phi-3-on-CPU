from fastapi import FastAPI
from pydantic import BaseModel
from llama_cpp import Llama
import logging

app = FastAPI()

# Set up logging
logging.basicConfig(level=logging.INFO)

# Initialize the model
llm = Llama(
    model_path="./Phi-3-mini-4k-instruct-q4.gguf",
    n_ctx=4096,
    n_threads=8,
    n_gpu_layers=0,  # Set to 0 if running on CPU
)


class Item(BaseModel):
    prompt: str


@app.post("/predict")
async def predict(item: Item):
    prompt = item.prompt
    if not prompt:
        logging.info("No prompt provided")
        return {"error": "No prompt provided"}

    logging.info(f"Received prompt: {prompt}")

    # Run the model
    output = llm(f"\n{prompt}\n", max_tokens=256, stop=["<|end|>"], echo=False)
    logging.info(f"Model output: {output}")

    return {"response": output["choices"][0]["text"]}
