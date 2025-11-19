FROM python:3.11-slim

WORKDIR /app

# Instala git para pegar pacotes via git+
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

COPY . .

# Instala dependências principais
RUN pip install --no-cache-dir .

CMD ["python", "main.py"]
