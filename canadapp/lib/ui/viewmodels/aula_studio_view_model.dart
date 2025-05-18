import 'package:flutter/material.dart';
import '../../data/repositories/aula_studio_repository.dart';
import '../../domain/models/aula_studio.dart';

class AulaStudioViewModel extends ChangeNotifier {
  final AulaStudioRepository _repository;
  AulaStudio? _stato;
  AulaStudio? get stato => _stato;

  AulaStudioViewModel(this._repository) {
    _ascoltaDisponibilita();
  }

  void _ascoltaDisponibilita() {
    _repository.disponibilitaStream().listen((dati) {
      _stato = dati;
      notifyListeners();
    });
  }
}
