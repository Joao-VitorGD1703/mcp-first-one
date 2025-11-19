FROM python:3.12-slim

WORKDIR /app

# 2. INSTALAÇÃO DE DEPENDÊNCIAS DO SISTEMA
# O git é necessário para baixar a dependência 'mcp' via URL do Git.
# build-essential é necessário para compilar CFFI/cryptography, que é uma dependência comum.
RUN apt-get update && \
    apt-get install -y git build-essential && \
    rm -rf /var/lib/apt/lists/*

# 3. INSTALAÇÃO EXPLÍCITA DE DEPENDÊNCIAS ESSENCIAIS
# Uvicorn e FastAPI são dependências CRÍTICAS para rodar o CMD.
# É bom instalá-los explicitamente ou garantir que o pyproject.toml os resolva.
# Como o FastMCP usa FastAPI/Starlette, garantimos que Uvicorn e Starlette estejam disponíveis.
# FastAPI é resolvida via dependência do 'mcp-server' (se o pyproject.toml estiver correto).
# Vamos instalar Uvicorn separadamente para garantir que ele esteja no PATH.
RUN pip install --no-cache-dir uvicorn==0.28.1

# 4. COPIA ARQUIVOS E INSTALA O PROJETO LOCAL
# Copiamos apenas os arquivos de configuração primeiro (para otimizar o cache do Docker)
COPY pyproject.toml .
COPY main.py .
COPY . .

# 5. INSTALAÇÃO DO PROJETO LOCAL
# Instala o 'mcp-server' e todas as dependências listadas no pyproject.toml (incluindo mcp[cli] e httpx)
RUN pip install --no-cache-dir .

# 6. COMANDO DE EXECUÇÃO
# O comando uvicorn aponta para o aplicativo FastAPI no seu arquivo main.py.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]