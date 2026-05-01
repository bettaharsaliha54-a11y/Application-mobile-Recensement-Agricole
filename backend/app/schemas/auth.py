from typing import Optional, List
from pydantic import BaseModel, EmailStr, ConfigDict

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str

class RoleOut(BaseModel):
    name: str
    description_fr: Optional[str]
    description_ar: Optional[str]

class UserResponse(BaseModel):
    id: int
    nom_fr: str
    prenom_fr: str
    email: EmailStr
    status: bool
    roles: List[RoleOut]
    
    model_config = ConfigDict(from_attributes=True)
