from fastapi import FastAPI

app = FastAPI(title="API Adopciones")

@app.get("/")
def raiz():
    return {"ok": True}
