import 'package:flutter/material.dart';
import '../../data/repositories/aula_studio_repository.dart';
import '../../domain/models/aula_studio.dart';

class AulaStudioViewModel extends ChangeNotifier {
  final AulaStudioRepository _repository;
  AulaStudio? _stato;
  AulaStudio? get stato => _stato;
  bool qrState = true; // true = decrementa, false = incrementa

  AulaStudioViewModel(this._repository) {
    _ascoltaDisponibilita();
  }

  void _ascoltaDisponibilita() {
    _repository.disponibilitaStream().listen((dati) {
      _stato = dati;
      notifyListeners();
    });
  
  }
   Future<void> handleQrCodeScanned(String code) async {
    if (qrState) {
      await _repository.decrementaDisponibilita();
    } else {
      await _repository.incrementaDisponibilita();
    }
    // cambia stato per prossimo scan
    qrState = !qrState;
  }
}
