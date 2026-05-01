from typing import Optional
from sqlalchemy.orm import Session
from app.models.user import User
from app.core import security

class AuthService:
    @staticmethod
    def get_user_by_email(db: Session, email: str) -> Optional[User]:
        return db.query(User).filter(User.email == email).first()

    @staticmethod
    def authenticate_user(db: Session, email: str, password: str) -> Optional[User]:
        user = AuthService.get_user_by_email(db, email)
        if not user:
            return None
        if not security.verify_password(password, user.password_hash):
            return None
        return user

    @staticmethod
    def create_user(db: Session, email: str, password: str, **kwargs) -> User:
        hashed_password = security.get_password_hash(password)
        db_user = User(
            email=email,
            password_hash=hashed_password,
            **kwargs
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

auth_service = AuthService()
