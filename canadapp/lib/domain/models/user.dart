class User {
  final String id;
  final String email;
  final String password;
  final bool certificatoMedico;
  final bool isStudy;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.certificatoMedico,
    required this.isStudy,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      certificatoMedico: json['certificatoMedico'],
      isStudy: json['isStudy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'certificatoMedico': certificatoMedico,
      'isStudy': isStudy,
    };
  }
}
