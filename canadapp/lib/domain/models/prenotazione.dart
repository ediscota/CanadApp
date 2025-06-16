import 'package:cloud_firestore/cloud_firestore.dart';

class Prenotazione {
  final String id;
  final String userId;
  final String dataOra;

  Prenotazione({required this.id, required this.userId, required this.dataOra});

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      id: json['id'],
      userId: json['userId'],
      dataOra: json['dataOra'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'dataOra': dataOra.toString()};
  }
}
