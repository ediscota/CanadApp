import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/prenotazione.dart';

class PrenotazioniService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Prenotazione>> fetchPrenotazioni() async {
    try {
      final prenotazioni = await _firestore.collection('prenotazioni').get();
      return prenotazioni.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Inserisci l'id del documento
        return Prenotazione.fromJson(data);
      }).toList();
    } catch (e) {
      // log errore
      rethrow;
    }
  }
}

// fai anche la post

