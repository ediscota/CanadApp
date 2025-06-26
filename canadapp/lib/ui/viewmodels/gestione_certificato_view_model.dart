import 'dart:io';
import 'package:canadapp/data/repositories/gestione_certificato_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestioneCertificatoViewModel extends ChangeNotifier {
  final GestioneCertificatoRepository _repository;

  GestioneCertificatoViewModel(this._repository) {
    _loadCertificatoDati();
  }

  String? certificatoUrl;
  DateTime? dataScadenza;
  File? fileSelezionato;
  bool isLoading = true;

  Future<void> _loadCertificatoDati() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final data = await _repository.fetchCertificate(userId);
      certificatoUrl = data['url'];
      dataScadenza = data['dataScadenza'];
    }
    isLoading = false;
    notifyListeners();
  }

  void setFile(File file) {
    fileSelezionato = file;
    notifyListeners();
  }

  void setDataScadenza(DateTime date) {
    dataScadenza = date;
    notifyListeners();
  }

  Future<void> uploadCertificate() async {
    if (fileSelezionato == null || dataScadenza == null) return;

    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final url = await _repository.uploadCertificate(
        userId,
        fileSelezionato!,
        dataScadenza!,
      );
      certificatoUrl = url;
    }

    fileSelezionato = null;
    isLoading = false;
    notifyListeners();
  }

  String get dataScadenzaString =>
      dataScadenza != null
          ? '${dataScadenza!.day}/${dataScadenza!.month}/${dataScadenza!.year}'
          : '';

  Future<void> deleteCertificate() async {
    isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      await _repository.deleteCertificate(userId);
      certificatoUrl = null;
      dataScadenza = null;
    }
    isLoading = false;
    notifyListeners();
  }
}
