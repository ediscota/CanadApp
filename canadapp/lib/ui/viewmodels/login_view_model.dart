import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository _repository;

  bool _isLoading = false;
  String? _errore;
  User? _utente;

  LoginViewModel(this._repository);

  bool get isLoading => _isLoading;
  String? get errore => _errore;
  User? get utente => _utente;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errore = null;
    notifyListeners();

    try {
      final result = await _repository.login(email, password);
      if (result == null) {
        _errore = 'Email o password errate';
        _utente = null;
        return false;
      } else {
        _utente = result;
        return true;
      }
    } catch (e) {
      _errore = 'Errore di connessione';
      _utente = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}