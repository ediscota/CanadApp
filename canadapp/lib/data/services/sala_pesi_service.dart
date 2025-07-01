import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/prenotazione.dart';

class SalaPesiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Prenotazione>> fetchPrenotazioni() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) {
        print("Nessun utente loggato trovato nella sessione.");
        return [];
      }
      final querySnapshot = await _firestore.collection('prenotazioni').get();
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

  Future<List<String>> aggiungiPrenotazione(String data, String ora) async {
    List<String> errors = [];
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('prenotazioni')
            .where('data', isEqualTo: data)
            .where('ora', isEqualTo: ora)
            .get();
    // Controllo capienza massima
    if (querySnapshot.docs.length > 1) {
      // TODO modificare a 7
      errors.add('La fascia oraria selezionata è già piena.');
    }
    // Controllo certificazione utente
    bool isCertificato = await isUtenteCertificato();
    if (!isCertificato) {
      errors.add('Utente non certificato o certificato scaduto.');
    }
    if (errors.isNotEmpty) {
      return errors;
    }
    await FirebaseFirestore.instance.collection('prenotazioni').add({
      'userId': userId,
      'data': data,
      'ora': ora,
    });
    return errors;
  }

  Future<bool> isUtenteCertificato() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final scadenzaCertificatoString =
        userSnapshot.data()?['scadenzaCertificato'];
    if (scadenzaCertificatoString == null) {
      return false; // certificato mai inserito
    }
    try {
      final DateTime dataScadenza = DateTime.parse(scadenzaCertificatoString);
      final DateTime oggi = DateTime.now();
      if (dataScadenza.isBefore(oggi)) {
        return false; // certificato scaduto
      } else {
        return true; // certificato valido
      }
    } catch (e) {
      return false; // Errore di parsing, trattalo come non valido
    }
  }

  Future<bool> isOrarioDisponibile(String data, String ora) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('prenotazioni')
            .where('data', isEqualTo: data)
            .where('ora', isEqualTo: ora)
            .get();
    return snapshot.docs.length < 7;
  }

  Future<void> deletePrenotazione(String id) async {
    try {
      await _firestore.collection('prenotazioni').doc(id).delete();
    } catch (e) {
      throw Exception('Errore durante l\'eliminazione della prenotazione: $e');
    }
  }
}
