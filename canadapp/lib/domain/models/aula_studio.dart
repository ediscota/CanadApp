class AulaStudio {
  final int disponibilita;

  AulaStudio({
    required this.disponibilita,
  });

  factory AulaStudio.fromJson(Map<String, dynamic> json) {
    return AulaStudio(
      disponibilita: json['disponibilita'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disponibilita': disponibilita,
    };
  }
}