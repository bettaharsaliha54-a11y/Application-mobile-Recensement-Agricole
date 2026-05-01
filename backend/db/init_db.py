from sqlalchemy.orm import Session
from crud import user as crud_user
from schemas.user import UserCreate
from db.session import SessionLocal

def init_db(db: Session) -> None:
    # Create first recenseur if it doesn't exist
    user = crud_user.get_by_username(db, username="recenseur1")
    if not user:
        user_in = UserCreate(
            username="recenseur1",
            password="password123",
            full_name="Mahsi Al-Awwal",
            is_superuser=True,
        )
        user = crud_user.create(db, obj_in=user_in)
        print(f"Created default user: {user.username}")
    else:
        print("Default user already exists.")

if __name__ == "__main__":
    db = SessionLocal()
    init_db(db)
    db.close()
