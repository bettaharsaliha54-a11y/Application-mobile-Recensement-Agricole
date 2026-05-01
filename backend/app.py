# filename: main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import Optional

# Create FastAPI app instance
app = FastAPI(title="Example FastAPI App", version="1.0.0")

# Define a Pydantic model for request validation
class Item(BaseModel):
    name: str = Field(..., min_length=1, max_length=50, description="Name of the item")
    price: float = Field(..., gt=0, description="Price must be greater than zero")
    description: Optional[str] = Field(None, max_length=200)

# In-memory "database"
items_db = {}

@app.get("/controler")
def read_root():
    """Root endpoint."""
    return {"message": "controller "}

@app.post("/items/{item_id}")
def create_item(item_id: int, item: Item):
    """Create a new item."""
    if item_id in items_db:
        raise HTTPException(status_code=400, detail="Item ID already exists")
    items_db[item_id] = item
    return {"item_id": item_id, "item": item}

@app.get("/items/{item_id}")
def read_item(item_id: int):
    """Retrieve an item by ID."""
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"item_id": item_id, "item": items_db[item_id]}

@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    """Update an existing item."""
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    items_db[item_id] = item
    return {"item_id": item_id, "item": item}

@app.delete("/items/{item_id}")
def delete_item(item_id: int):
    """Delete an item."""
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    del items_db[item_id]
    return {"message": f"Item {item_id} deleted successfully"}
