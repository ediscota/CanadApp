import 'package:canadapp/data/repositories/sala_pesi_repository.dart';
import 'package:canadapp/domain/models/prenotazione.dart';
import 'package:flutter/material.dart';

class SalaPesiViewModel extends ChangeNotifier {
  final SalaPesiRepository _repository;
  List<Prenotazione> _prenotazioni = [];
  late DateTime _dataSelezionata;
  List<String> errors = [];
  bool _isLoading = false;

  SalaPesiViewModel(this._repository) {
    fetchPrenotazioni();
  }

  List<Prenotazione> get prenotazioni => _prenotazioni;
  bool get isLoading => _isLoading;

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

  Future<void> eliminaPrenotazione(String prenotazioneId) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _repository.deletePrenotazione(prenotazioneId);
      // Rimuovo la prenotazione dalla lista locale
      _prenotazioni.removeWhere((p) => p.id == prenotazioneId);
      notifyListeners();
    } catch (e) {
      errors.add('Errore durante l\'eliminazione della prenotazione');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
