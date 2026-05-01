from fastapi import APIRouter
from api.v1.endpoints import auth, exploitant, exploitation, recensement

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(exploitant.router, prefix="/exploitants", tags=["Exploitants"])
api_router.include_router(exploitation.router, prefix="/exploitations", tags=["Exploitations"])
api_router.include_router(recensement.router, prefix="/recensements", tags=["Recensements"])
