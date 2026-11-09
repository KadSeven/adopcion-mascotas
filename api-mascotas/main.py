from fastapi import FastAPI

app = FastAPI(title="API Mascotas")

@app.get("/")
def raiz():
    return {"ok": True}
