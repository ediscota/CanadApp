import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/prenotazione.dart';

class SalaPesiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Prenotazione>> fetchPrenotazioni() async {
  try {
    // Recupera l'ID dell'utente dalla sessione
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print("Nessun utente loggato trovato nella sessione.");
      return [];
    }

    // Query filtrata per userId
    final querySnapshot = await _firestore.collection('prenotazioni').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Prenotazione.fromJson(data);
    }).toList();
  } catch (e) {
    print("Errore durante il recupero delle prenotazioni: $e");
    rethrow;
  }
 } 
 Future<void> aggiungiPrenotazione(DateTime dataOra) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  await FirebaseFirestore.instance.collection('prenotazioni').add({
    'userId': userId,
    'dataOra': Timestamp.fromDate(dataOra),
  });
}
}


