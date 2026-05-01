from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from app.routers import auth
# سنضيف البقية لاحقاً (exploitants, exploitations, sync)

app = FastAPI(title="Agriculture RGA API", version="1.0.0")

# CORS (السماح للتابلت بالاتصال بالسيرفر)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# تضمين مسارات التوثيق (Authentication)
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])

@app.get("/")
def read_root():
    return {"message": "Sérveur Agriculture RGA Active 🌐", "status": "online"}
