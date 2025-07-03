import 'package:canadapp/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/aula_studio_repository.dart';
import '../../domain/models/aula_studio.dart';

class AulaStudioViewModel extends ChangeNotifier {
  final AulaStudioRepository _repository;
  final UserRepository _userRepository;
  AulaStudio? _stato;
  AulaStudio? get stato => _stato;
  bool _qrState = false;
  bool get qrState => _qrState;

  AulaStudioViewModel(this._repository, this._userRepository) {
    _ascoltaDisponibilita();
    getQrCodeState();
  }

  void _ascoltaDisponibilita() {
    _repository.disponibilitaStream().listen((dati) {
      _stato = dati;
      notifyListeners();
    });
  }

  Future<void> getQrCodeState() async {
    final instance = await SharedPreferences.getInstance();
    bool qrState = instance.getBool('qrState') ?? false;
    _qrState = qrState;
  }

  Future<void> handleQrCodeScanned(String code) async {
    final instance = await SharedPreferences.getInstance();
    bool qrState = instance.getBool('qrState') ?? false;
    String userId = instance.getString('userId') ?? '';
    print(code + ' ' + qrState.toString() + ' ' + userId);
    if (qrState) {
      await _repository.incrementaDisponibilita();
    } else {
      await _repository.decrementaDisponibilita();
    }
    // cambia stato per prossimo scan
    qrState = !qrState;

    await _userRepository.setStudy(userId, qrState);
    instance.setBool('qrState', qrState);
    _qrState = qrState;
    notifyListeners();
  }
}
