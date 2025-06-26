import 'package:canadapp/data/repositories/sala_pesi_repository.dart';
import 'package:canadapp/domain/models/prenotazione.dart';
import 'package:flutter/material.dart';

class SalaPesiViewModel extends ChangeNotifier {
  final SalaPesiRepository _repository;
  List<Prenotazione> _prenotazioni = [];
  late  DateTime _dataSelezionata;
  List<String> errors = [];

  SalaPesiViewModel(this._repository) {
    fetchPrenotazioni();
  }

  List<Prenotazione> get prenotazioni => _prenotazioni;

  Future<void> fetchPrenotazioni() async {
    _prenotazioni = await _repository.fetchPrenotazioni();
    notifyListeners();
  }

    void setDataSelezionata(DateTime data) {
    _dataSelezionata = data;
    notifyListeners();
  }

  Future<void> aggiungiPrenotazione(String data, String ora) async {
    errors = await _repository.aggiungiPrenotazione(data, ora);
    notifyListeners();
    await fetchPrenotazioni();
  }
  void clearErrors() {
    errors = [];
    notifyListeners();
  }

}
