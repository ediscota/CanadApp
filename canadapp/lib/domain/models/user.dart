class User {
  final String id;
  final String email;
  final String password;
  final bool certificatoMedico;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.certificatoMedico,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      certificatoMedico: json['certificatoMedico']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'certificatoMedico': certificatoMedico,
    };
  }
}