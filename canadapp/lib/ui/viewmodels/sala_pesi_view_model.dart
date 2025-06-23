import 'package:canadapp/data/repositories/sala_pesi_repository.dart';
import 'package:canadapp/domain/models/prenotazione.dart';
import 'package:flutter/material.dart';

class SalaPesiViewModel extends ChangeNotifier {
  final SalaPesiRepository _repository;
  List<Prenotazione> _prenotazioni = [];
  late  DateTime _dataSelezionata;

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

  Future<void> aggiungiPrenotazione(DateTime dataOra) async {
    // Controllo se esiste già una prenotazione per quell'orario
    bool esiste = _prenotazioni.any((prenotazione) => prenotazione.dataOra == dataOra);

    if (esiste) {
      throw Exception('Esiste già una prenotazione per questa data e ora.');
    }
    await _repository.aggiungiPrenotazione(dataOra);
    await fetchPrenotazioni();
  }
}
