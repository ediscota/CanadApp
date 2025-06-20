import 'dart:io';
import 'package:canadapp/data/services/gestione_certificato_service.dart';

class GestioneCertificatoRepository {
  final GestioneCertificatoService _service;

  GestioneCertificatoRepository(this._service);

  Future<Map<String, dynamic>> fetchCertificate(String userId) async {
    return await _service.getCertificateData(userId);
  }

  Future<String> uploadCertificate(
    String userId,
    File file,
    DateTime dataScadenza,
  ) async {
    final url = await _service.uploadFile(userId, file, dataScadenza);
    return url;
  }

  Future<void> deleteCertificate(String userId) async {
    await _service.deleteCertificate(userId);
  }
}
