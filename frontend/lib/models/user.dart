class User {
  final int id;
  final String nomFr;
  final String nomAr;
  final String prenomFr;
  final String prenomAr;
  final String email;
  final String? tel;

  User({
    required this.id,
    required this.nomFr,
    required this.nomAr,
    required this.prenomFr,
    required this.prenomAr,
    required this.email,
    this.tel,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nomFr: map['nom_fr'] ?? '',
      nomAr: map['nom_ar'] ?? '',
      prenomFr: map['prenom_fr'] ?? '',
      prenomAr: map['prenom_ar'] ?? '',
      email: map['email'],
      tel: map['tel'],
    );
  }
}
