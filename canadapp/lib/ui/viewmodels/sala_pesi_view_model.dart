import 'package:canadapp/data/repositories/sala_pesi_repository.dart';
import 'package:canadapp/domain/models/prenotazione.dart';
import 'package:flutter/material.dart';

class SalaPesiViewModel extends ChangeNotifier {
  final SalaPesiRepository _repository;
  List<Prenotazione> _prenotazioni = [];

  SalaPesiViewModel(this._repository) {
    fetchPrenotazioni();
  }

  List<Prenotazione> get prenotazioni => _prenotazioni;

  Future<void> fetchPrenotazioni() async {
    //print("Metodo");
    _prenotazioni = await _repository.fetchPrenotazioni();
    notifyListeners();
  }
}
