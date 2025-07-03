import 'dart:io';
import 'package:canadapp/data/repositories/gestione_certificato_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestioneCertificatoViewModel extends ChangeNotifier {
  final GestioneCertificatoRepository _repository;

  GestioneCertificatoViewModel(this._repository) {
    _loadCertificatoDati();
  }

  //String? certificatoUrl;
  String? dataScadenza;
  File? fileSelezionato;
  bool isLoading = true;
  bool certificatoCaricato = false;

  bool get isValidForm {
    print(dataScadenza);
    return fileSelezionato != null &&
        dataScadenza != null &&
        dataScadenza!.isNotEmpty;
  }

  Future<void> _loadCertificatoDati() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final data = await _repository.fetchCertificate(userId);
      //certificatoUrl = data['url'];
      if (data['dataScadenza'] != null) {
        dataScadenza = data['dataScadenza'];
        final parsed = DateTime.tryParse(dataScadenza!);
        if (parsed != null && parsed.isAfter(DateTime.now())) {
          certificatoCaricato = true;
        }
      }

      //dataScadenza = data['dataScadenza'];
    }
    isLoading = false;
    notifyListeners();
  }

  void setFile(File file) {
    fileSelezionato = file;
    notifyListeners();
  }

  void setDataScadenza(String date) async {
    dataScadenza = date;
    final instance = await SharedPreferences.getInstance();
    instance.setString('scadenzaCertificato', date);
    notifyListeners();
  }

  Future<void> uploadCertificate(String date) async {
    print(date);
    if (fileSelezionato == null || dataScadenza == null) return;

    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      await _repository.uploadCertificate(
        userId,
        fileSelezionato!,
        dataScadenza!,
      );
      setDataScadenza(date);
      certificatoCaricato = true;
      //certificatoUrl = url;
    }

    fileSelezionato = null;
    isLoading = false;
    notifyListeners();
  }

  String get dataScadenzaString => dataScadenza ?? '';
  String get fileName => fileSelezionato?.path.split('/').last ?? '';

  Future<String> getCertificatoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      return await _repository.getCertificatoUrl(userId);
    }
    return '';
  }
}
