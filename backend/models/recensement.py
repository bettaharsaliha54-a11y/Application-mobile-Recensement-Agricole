from sqlalchemy import Column, Integer, String, Float, Boolean, ForeignKey, DateTime, func
from sqlalchemy.orm import relationship
from db.base import Base

# 1. المخطط الرئيسي للإحصاء
class Recensement(Base):
    __tablename__ = "recensement"
    id = Column(Integer, primary_key=True, index=True)
    date_created = Column(DateTime, default=func.now())
    status = Column(String, default="completed") # draft/completed/synced
    
    # الروابط الأساسية
    exploitation_id = Column(Integer, ForeignKey("exploitation.id"), unique=True)
    exploitation = relationship("Exploitation", back_populates="recensement")
    
    recenseur_id = Column(Integer, ForeignKey("user.id"))
    
    # العلاقات مع الأجزاء السبعة المتبقية
    superficie = relationship("Superficie", uselist=False, back_populates="recensement")
    cultures = relationship("Cultures", uselist=False, back_populates="recensement")
    livestock = relationship("Livestock", uselist=False, back_populates="recensement")
    irrigation = relationship("Irrigation", uselist=False, back_populates="recensement")
    infrastructure = relationship("Infrastructure", uselist=False, back_populates="recensement")
    labor = relationship("Labor", uselist=False, back_populates="recensement")
    inputs = relationship("Inputs", uselist=False, back_populates="recensement")

# 3. قسم المساحة (Superficie)
class Superficie(Base):
    id = Column(Integer, primary_key=True)
    recensement_id = Column(Integer, ForeignKey("recensement.id"))
    area_sao = Column(Float, default=0) # المساحة الصالحة للزراعة
    area_cereal = Column(Float, default=0)
    area_fallow = Column(Float, default=0) # بور
    recensement = relationship("Recensement", back_populates="superficie")

# 4. قسم المحاصيل (Cultures)
class Cultures(Base):
    id = Column(Integer, primary_key=True)
    recensement_id = Column(Integer, ForeignKey("recensement.id"))
    has_cereals = Column(Boolean, default=False)
    has_vegetables = Column(Boolean, default=False)
    has_fruit_trees = Column(Boolean, default=False)
    recensement = relationship("Recensement", back_populates="cultures")

# 5. قسم المواشي (Livestock / Cheptel)
class Livestock(Base):
    id = Column(Integer, primary_key=True)
    recensement_id = Column(Integer, ForeignKey("recensement.id"))
    cattle_count = Column(Integer, default=0) # أبقار
    sheep_count = Column(Integer, default=0)  # أغنام
    goat_count = Column(Integer, default=0)   # ماعز
    camel_count = Column(Integer, default=0)  # إبل
    poultry_count = Column(Integer, default=0)# دواجن
    recensement = relationship("Recensement", back_populates="livestock")

# 6. قسم الري (Irrigation)
class Irrigation(Base):
    id = Column(Integer, primary_key=True)
    recensement_id = Column(Integer, ForeignKey("recensement.id"))
    use_borehole = Column(Boolean, default=False)
    use_well = Column(Boolean, default=False)
    drip_irrigation = Column(Boolean, default=False)
    recensement = relationship("Recensement", back_populates="irrigation")

# 7. قسم الهياكل القاعدية (Infrastructure)
class Infrastructure(Base):
    id = Column(Integer, primary_key=True)
    recensement_id = Column(Integer, ForeignKey("recensement.id"))
    has_hangar = Column(Boolean, default=False)
    has_stable = Column(Boolean, default=False)
    recensement = relationship("Recensement", back_populates="infrastructure")

# 8. قسم اليد العاملة (Labor / Main d'œuvre)
class Labor(Base):
    id = Column(Integer, primary_key=True)
    recensement_id = Column(Integer, ForeignKey("recensement.id"))
    permanent_count = Column(Integer, default=0)
    seasonal_count = Column(Integer, default=0)
    recensement = relationship("Recensement", back_populates="labor")

# 9. قسم المدخلات (Inputs / Intrants)
class Inputs(Base):
    id = Column(Integer, primary_key=True)
    recensement_id = Column(Integer, ForeignKey("recensement.id"))
    use_certified_seeds = Column(Boolean, default=False)
    use_fertilizers = Column(Boolean, default=False)
    recensement = relationship("Recensement", back_populates="inputs")
