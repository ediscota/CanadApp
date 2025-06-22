import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/prenotazione.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalaPesiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Prenotazione>> fetchPrenotazioniUtente() async {
    //print("Metodo");
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) {
        throw Exception("Utente non loggato: userId mancante");
      }

      final now = DateTime.now();

      // Firestore non supporta direttamente confronti su Timestamp+String nella stessa query senza indice
      final querySnapshot = await _firestore
          .collection('prenotazioni')
          .where('userId', isEqualTo: userId)
          .where('dataOra', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Prenotazione.fromJson(data);
      }).toList();
    } catch (e) {
      print("Errore durante il recupero delle prenotazioni utente: $e");
      rethrow;
    }
  }
  }
// fai anche la post
