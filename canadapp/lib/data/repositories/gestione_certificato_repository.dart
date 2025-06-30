import 'dart:io';
import 'package:canadapp/data/services/gestione_certificato_service.dart';
import 'package:canadapp/data/services/notifiche_service.dart';

class GestioneCertificatoRepository {
  final GestioneCertificatoService _service;

  GestioneCertificatoRepository(this._service);

  Future<Map<String, dynamic>> fetchCertificate(String userId) async {
    return await _service.getCertificateData(userId);
  }

  Future<void> uploadCertificate(
    String userId,
    File file,
    String dataScadenza,
  ) async {
    await _service.uploadFile(userId, file, dataScadenza);
    await NotificheService()
        .deleteNotificaScadenzaCertificato(); // Cancella notifica precedente se esiste
    await NotificheService().notificaScadenzaCertificato(dataScadenza);
    /*await NotificheService().showNotification(
      title: 'Aggiornamento Certificato',
      body: 'Il tuo certificato è stato aggiornato.',
    );*/
    //return url;
  }

  Future<String> getCertificatoUrl(String userId) async {
    return await _service.getCertificatoUrl(userId);
  }
}
