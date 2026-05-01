from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import timedelta
from jose import jwt, JWTError

from app.database import get_db
from app.services.auth_service import auth_service
from app.schemas.auth import LoginRequest, TokenResponse, UserResponse
from app.core import security
from app.dependencies import get_current_user

router = APIRouter()

@router.post("/login", response_model=TokenResponse)
def login(request: LoginRequest, db: Session = Depends(get_db)):
    user = auth_service.authenticate_user(db, email=request.email, password=request.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="الايميل أو كلمة السر غير صحيحة",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not user.status:
        raise HTTPException(status_code=400, detail="هذا المستخدم غير مفعل")
    
    access_token = security.create_access_token(subject=user.id)
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/me", response_model=UserResponse)
def read_current_user(current_user=Depends(get_current_user)):
    """جلب بيانات المحصي الداخل حالياً"""
    return current_user
