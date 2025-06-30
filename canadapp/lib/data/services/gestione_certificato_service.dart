import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GestioneCertificatoService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> getCertificateData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();
      if (data == null || data['scadenzaCertificato'] == null) {
        return {'dataScadenza': null};
      }

      return {
        //'url': data['certificatoUrl'],
        'dataScadenza': data['scadenzaCertificato'],
      };
    } catch (e) {
      print('Errore durante il recupero dei dati del certificato: $e');
      return {'dataScadenza': null};
    }
  }

  Future<void> uploadFile(String userId, File file, String dataScadenza) async {
    try {
      final ref = _storage.ref().child('certificati/$userId');
      await ref.putFile(file);
      //String url = await ref.getDownloadURL();
      await _firestore.collection('users').doc(userId).update({
        //'certificatoUrl': url,
        'scadenzaCertificato': dataScadenza,
      });
      //return url;
    } catch (e) {
      print('Errore durante il caricamento del file: $e');
      rethrow;
    }
  }

  //mi prendo l'url del certificato da Firebase Storage
  Future<String> getCertificatoUrl(String userId) async {
    try {
      final ref = _storage.ref().child('certificati/$userId');
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Errore durante il recupero dell\'URL del certificato: $e');
      return '';
    }
  }
}
