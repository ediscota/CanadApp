import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestioneCertificatoViewModel extends ChangeNotifier {
  DateTime? _dataScadenza;
  File? _certificato;

  // Getters
  DateTime? get dataScadenza => _dataScadenza;
  File? get certificato => _certificato;

  // Setters
  void setDataScadenza(DateTime data) {
    _dataScadenza = data;
    notifyListeners();
  }

  void caricaCertificato(File file) {
    _certificato = file;
    notifyListeners();
  }

  bool get certificatoValido {
    if (_dataScadenza == null) return false;
    return _dataScadenza!.isAfter(DateTime.now());
  }

  void resettaCertificato() {
    _dataScadenza = null;
    _certificato = null;
    notifyListeners();
  }

// TODO: cosi non va bene, il try {await FirebaseFirestore.instance.collection('users').doc(userId).update lo fai in un metodo in userservice,
// poi lo wrappi in un metodo in userrepository, e infine questo metodo chiama il metodo in unserrepository
  Future<void> salvaSuFirestore(String userId) async {
    if (_dataScadenza == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'dataScadenza': Timestamp.fromDate(_dataScadenza!),
      });
    } catch (e) {
      debugPrint('Errore durante il salvataggio: $e');
      rethrow;
    }
  }
}