from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return {"service": "order", "status": "ok"}

@app.get("/orders/{user_id}")
def get_orders(user_id: int):
    return {
        "user_id": user_id,
        "orders": [
            {"order_id": 101, "item": "Laptop"},
            {"order_id": 102, "item": "Keyboard"}
        ]
    }
