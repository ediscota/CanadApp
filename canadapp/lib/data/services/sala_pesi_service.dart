import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/prenotazione.dart';

class SalaPesiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Prenotazione>> fetchPrenotazioni() async {
    //print("Metodo");
    try {
      final prenotazioni = await _firestore.collection('prenotazioni').get();
      print(prenotazioni.docs);
      return prenotazioni.docs.map((doc) {
        print(doc.data());
        final data = doc.data();
        data['id'] = doc.id; // Inserisci l'id del documento
        return Prenotazione.fromJson(data);
      }).toList();
    } catch (e) {
      print("Errore durante il recupero delle prenotazioni: $e");
      // log errore
      rethrow;
    }
  }
}

// fai anche la post
