//import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String password;
  final String scadenzaCertificato;
  final bool isStudy;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.scadenzaCertificato,
    required this.isStudy,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      scadenzaCertificato: json['scadenzaCertificato'],
      isStudy: json['isStudy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'scadenzaCertificato': scadenzaCertificato,
      'isStudy': isStudy,
    };
  }
}
