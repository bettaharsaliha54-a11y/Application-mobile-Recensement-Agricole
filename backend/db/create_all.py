from db.session import engine
from db.base import Base
# Import all models to ensure they are registered with Base
import models

def create_tables():
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("Tables created successfully.")

if __name__ == "__main__":
    create_tables()
