from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Table, Text, DateTime, func
from sqlalchemy.orm import relationship
from app.database import Base

# Many-to-Many relationship table for users and roles
user_roles = Table(
    "user_roles",
    Base.metadata,
    Column("user_id", Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True),
    Column("role_id", Integer, ForeignKey("roles.id", ondelete="CASCADE"), primary_key=True),
)

class Role(Base):
    __tablename__ = "roles"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    description_fr = Column(String(150))
    description_ar = Column(String(150))
    
    users = relationship("User", secondary=user_roles, back_populates="roles")

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(100), nullable=False)
    nom_ar = Column(String(100))
    prenom_fr = Column(String(100), nullable=False)
    prenom_ar = Column(String(100))
    email = Column(String(150), unique=True, nullable=False, index=True)
    password_hash = Column(Text, nullable=False)
    tel = Column(String(30))
    status = Column(Boolean(), default=True)
    created_at = Column(DateTime, default=func.now())
    
    roles = relationship("Role", secondary=user_roles, back_populates="users")
