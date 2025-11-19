# 1. IMAGEM BASE: MUDAR para Python 3.12 (ou mais recente) para satisfazer o requisito do pyproject.toml
FROM python:3.12-slim

WORKDIR /app

# 2. INSTALAÇÃO DE DEPENDÊNCIAS DO SISTEMA (git e outras ferramentas de build)
# O git é necessário para baixar a dependência 'mcp' via URL do Git.
RUN apt-get update && \
    apt-get install -y git build-essential && \
    rm -rf /var/lib/apt/lists/*

# 3. COPIA CÓDIGO E INSTALA DEPENDÊNCIAS
# Copiamos primeiro os arquivos de configuração para que o Docker possa usar o cache
COPY pyproject.toml .
COPY main.py .
COPY . .

# 4. INSTALAÇÃO DO PROJETO
# Usamos o 'pip install .' para instalar o 'mcp-server' (e suas dependências, como httpx e mcp[cli])
# A flag --no-cache-dir garante que o build seja repetível e mais limpo.
RUN pip install --no-cache-dir .

# 5. COMANDO DE EXECUÇÃO
# Nota: Você provavelmente precisa rodar o servidor FastAPI com uvicorn, e não apenas o python.
# Assumindo que você usará o uvicorn para rodar o 'main.py' (que contém a app FastAPI)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]