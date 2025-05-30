FROM python:3.10

RUN apt-get update && apt-get install -y git curl
RUN ln -sf /usr/local/bin/python3 /usr/local/bin/python

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Preload the model
RUN python -c "from transformers import AutoTokenizer, AutoModelForCausalLM; \
    AutoTokenizer.from_pretrained('Qwen/Qwen2.5-Coder-0.5B-Instruct', trust_remote_code=True); \
    AutoModelForCausalLM.from_pretrained('Qwen/Qwen2.5-Coder-0.5B-Instruct', trust_remote_code=True)"

COPY serve.py inference.py evaluate.py ./

# inference + evaluation
CMD ["python", "inference.py"]
