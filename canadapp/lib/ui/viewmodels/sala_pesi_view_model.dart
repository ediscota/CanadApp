import 'package:canadapp/data/repositories/sala_pesi_repository.dart';
import 'package:canadapp/domain/models/prenotazione.dart';
import 'package:flutter/material.dart';

class SalaPesiViewModel extends ChangeNotifier {
  late SalaPesiRepository _repository;
  List<Prenotazione> _prenotazioni = [];

  SalaPesiViewModel(this._repository);

  // Costruttore vuoto usato per l'inizializzazione iniziale
  SalaPesiViewModel.empty();

  set repository(SalaPesiRepository repo) {
    _repository = repo;
  }

  List<Prenotazione> get prenotazioni => _prenotazioni;

  Future<void> fetchPrenotazioniUtente() async {
    try {
      print("Chiamata fetchPrenotazioniUtente()");
      _prenotazioni = await _repository.fetchPrenotazioniUtente();
      notifyListeners();
    } catch (e) {
      print("Errore durante la fetch: $e");
    }
  }
}
