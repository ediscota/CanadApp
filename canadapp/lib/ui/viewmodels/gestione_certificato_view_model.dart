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

/*class GestioneCertificatoViewModel extends ChangeNotifier {
  final GestioneCertificatoRepository _repository;
  DateTime? _dataScadenza;
  File? _fileCertificato;
  //String? _userId;
  //String? _id;
  bool _isLoading = false;
  String? _fileUrl;
  //bool _certificatoMedico = false;

  GestioneCertificatoViewModel(this._repository);

  File? get fileCertificato => _fileCertificato;
  bool get isLoading => _isLoading;
  String? get fileUrl => _fileUrl;
  //bool get certificatoMedico => _certificatoMedico;
  bool get certificatoValido {
    if (_dataScadenza == null) return false;
    return _dataScadenza!.isAfter(DateTime.now());
  }

  int get giorniRimanenti {
    if (_dataScadenza == null) return 0;
    final oggi = DateTime.now();
    final differenza = _dataScadenza!.difference(oggi).inDays;
    return differenza > 0 ? differenza : 0;
  }

  int get mesiRimanenti {
    if (_dataScadenza == null) return 0;
    final oggi = DateTime.now();
    int mesi =
        (_dataScadenza!.year - oggi.year) * 12 +
        (_dataScadenza!.month - oggi.month);
    if (_dataScadenza!.day < oggi.day) mesi--;
    return mesi > 0 ? mesi : 0;
  }

  DateTime? get dataScadenza => _dataScadenza;

  // Setters
  void setCertificato(File certificato) {
    _fileCertificato = certificato;
    notifyListeners();
  }

  void resettaCertificato() {
    _dataScadenza = null;
    _fileCertificato = null;
    notifyListeners();
  }

  void caricaCertificato(File file) {
    _fileCertificato = file;
    notifyListeners();
  }

  void setDataScadenza(DateTime data) {
    _dataScadenza = data;
    notifyListeners();
  }

  Future<void> salvaCertificato() async {
    if (_fileCertificato == null || _dataScadenza == null) {
      throw Exception('Certificato e data di scadenza sono obbligatori');
    }
    _isLoading = true;
    notifyListeners();
    String userId = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getString('userId') ?? '',
    );
    try {
      await _repository.uploadCertificato(
        userId,
        _dataScadenza!,
        _fileCertificato!,
      );
      //_certificatoMedico = true;
    } catch (e) {
      debugPrint('Errore durante il salvataggio del certificato: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> caricaDatiCertificato() async {
    _isLoading = true;
    notifyListeners();
    String userId = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getString('userId') ?? '',
    );
    try {
      final data = await _repository.getCertificato(userId);
      //_certificato = certificato;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminaCertificato() async {
    _isLoading = true;
    notifyListeners();
    String userId = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getString('userId') ?? '',
    );
    try {
      await _repository.deleteCertificato(userId);
      _fileCertificato = null;
      _fileUrl = null;
      //_certificatoMedico = false;
    } catch (e) {
      debugPrint('Errore durante l\'eliminazione del certificato: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}*/
