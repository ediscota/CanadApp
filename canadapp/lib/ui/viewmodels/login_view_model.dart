import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        await SharedPreferences.getInstance().then((prefs) async {
          await prefs.setString('email', email);
          await prefs.setString('password', password);
          await prefs.setString('userId', _utente!.id);
        });
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
