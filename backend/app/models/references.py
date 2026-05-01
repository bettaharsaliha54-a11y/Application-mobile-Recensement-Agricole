from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Wilaya(Base):
    __tablename__ = "wilayas"
    id = Column(Integer, primary_key=True, index=True)
    code = Column(String(10), unique=True, nullable=False)
    nom_fr = Column(String(150), nullable=False)
    nom_ar = Column(String(150))
    communes = relationship("Commune", back_populates="wilaya")

class Commune(Base):
    __tablename__ = "communes"
    id = Column(Integer, primary_key=True, index=True)
    wilaya_id = Column(Integer, ForeignKey("wilayas.id", ondelete="CASCADE"), nullable=False)
    nom_fr = Column(String(150), nullable=False)
    nom_ar = Column(String(150))
    wilaya = relationship("Wilaya", back_populates="communes")

class NiveauInstruction(Base):
    __tablename__ = "niveau_instruction"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(100), nullable=False)
    nom_ar = Column(String(100))

class FormationAgricole(Base):
    __tablename__ = "formation_agricole"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(100), nullable=False)
    nom_ar = Column(String(100))

class StatutJuridique(Base):
    __tablename__ = "statut_juridique"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(150), nullable=False)
    nom_ar = Column(String(150))

class StatutTerre(Base):
    __tablename__ = "statut_terre"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(200), nullable=False)
    nom_ar = Column(String(200))

class ModeExploitation(Base):
    __tablename__ = "mode_exploitation"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(200), nullable=False)
    nom_ar = Column(String(200))

class Sexe(Base):
    __tablename__ = "sexe"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(20), nullable=False)
    nom_ar = Column(String(20))

class TypeAssurance(Base):
    __tablename__ = "type_assurance"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(50), nullable=False)
    nom_ar = Column(String(50))

class NatureExploitant(Base):
    __tablename__ = "nature_exploitant"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(50), nullable=False)
    nom_ar = Column(String(50))

class TypeActivite(Base):
    __tablename__ = "type_activite"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(100), nullable=False)
    nom_ar = Column(String(100))

class TypeTelephone(Base):
    __tablename__ = "type_telephone"
    id = Column(Integer, primary_key=True, index=True)
    nom_fr = Column(String(50), nullable=False)
    nom_ar = Column(String(50))
