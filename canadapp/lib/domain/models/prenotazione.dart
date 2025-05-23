class Prenotazione {
  final String id;
  final String userId;
  final DateTime dataOra;

  Prenotazione({
    required this.id,
    required this.userId,
    required this.dataOra,
  });

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      id: json['id'] ,
      userId: json['userId'] ,
      dataOra: DateTime.parse(json['dataOra']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'dataOra': dataOra.toIso8601String(),
    };
  }
}