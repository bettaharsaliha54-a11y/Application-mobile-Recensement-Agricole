from fastapi import APIRouter
router = APIRouter()
@router.post("/sync")
def sync_data(data: list):
    return {"message": "Data received", "items": len(data)}
