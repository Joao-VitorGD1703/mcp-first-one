from fastapi import FastAPI
from starlette.responses import StreamingResponse
from mcp.server.fastmcp import FastMCP

app = FastAPI()
mcp_app = FastMCP("MinhaLibMCP")

@mcp_app.tool()
def soma(a: int, b: int) -> int:
    return a + b

@mcp_app.tool()
def saudacao(nome: str) -> str:
    return f"Olá, {nome}!"

@app.get("/sse")
async def sse():
    return StreamingResponse(mcp_app.stream(), media_type="text/event-stream")