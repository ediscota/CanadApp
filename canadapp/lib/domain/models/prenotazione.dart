class Prenotazione {
  final String id;
  final String userId;
  final String data; // formato: yyyy-MM-dd
  final String ora;  // formato: HH:mm

  Prenotazione({
    required this.id,
    required this.userId,
    required this.data,
    required this.ora,
  });

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      id: json['id'],
      userId: json['userId'],
      data: json['data'],
      ora: json['ora'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'data': data,
      'ora': ora,
    };
  }
}