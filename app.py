from flask import Flask, request, jsonify
from llama_cpp import Llama
import logging

app = Flask(__name__)

# Set up logging
logging.basicConfig(level=logging.INFO)

# Initialize the model
llm = Llama(
    model_path="./Phi-3-mini-4k-instruct-q4.gguf",
    n_ctx=4096,
    n_threads=8,
    n_gpu_layers=0,  # Set to 0 if running on CPU
)


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    prompt = data.get("prompt")
    if not prompt:
        logging.info("No prompt provided")
        return jsonify({"error": "No prompt provided"}), 400

    logging.info(f"Received prompt: {prompt}")

    # Run the model
    output = llm(f"\n{prompt}\n", max_tokens=256, stop=[""], echo=False)
    logging.info(f"Model output: {output}")

    return jsonify({"response": output["choices"][0]["text"]}), 200


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
