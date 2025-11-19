# 1. IMAGEM BASE: Usando Python 3.12
FROM python:3.12-slim

WORKDIR /app

# 2. INSTALAÇÃO DE DEPENDÊNCIAS DO SISTEMA
# O git e build-essential são necessários.
RUN apt-get update && \
    apt-get install -y git build-essential && \
    rm -rf /var/lib/apt/lists/*

# 3. INSTALAÇÃO EXPLÍCITA DE DEPENDÊNCIAS ESSENCIAIS DO SERVIDOR
# Instalamos FastAPI e Uvicorn explicitamente.
# Isso garante que a dependência 'fastapi' seja resolvida e colocada no PATH.
RUN pip install --no-cache-dir fastapi uvicorn

# 4. COPIA ARQUIVOS
COPY pyproject.toml .
COPY main.py .
COPY . .

# 5. INSTALAÇÃO DO PROJETO LOCAL
# Instala o 'mcp-server' e todas as outras dependências do pyproject.toml
RUN pip install --no-cache-dir .

# 6. COMANDO DE EXECUÇÃO
# O uvicorn aponta para o aplicativo FastAPI (main:app).
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]