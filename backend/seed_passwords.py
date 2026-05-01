import sys
import os

sys.path.append(os.getcwd())

from app.database import SessionLocal
from app.models.user import User
from app.core import security
from app.services.auth_service import auth_service

def setup_recenseur():
    db = SessionLocal()
    try:
        user_email = "recenseur@agri.dz"
        user_pass = "Recensement123"

        # 1. البحث عن المستخدم
        user = db.query(User).filter(User.email == user_email).first()
        
        if user:
            # 2. إذا كان موجوداً، نحدث كلمة السر بعد تشفيرها
            user.password_hash = security.get_password_hash(user_pass)
            db.commit()
            print(f"🔄 تم تحديث كلمة السر للمستخدم {user_email}")
        else:
            # 3. إذا لم يكن موجوداً، نقوم بإنشائه بطريقة آمنة
            auth_service.create_user(
                db, 
                email=user_email, 
                password=user_pass,
                nom_fr="Recenseur",
                nom_ar="محصي",
                prenom_fr="Agricole",
                prenom_ar="فلاحي",
                status=True
            )
            print(f"✅ تم إنشاء المستخدم {user_email} بنجاح مع تشفير كلمة السر")
            
    except Exception as e:
        print(f"❌ حدث خطأ: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    setup_recenseur()
