import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/aula_studio.dart';

class AulaStudioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _docPath = 'config/aula_studio';

  Future<AulaStudio?> getDisponibilita() async {
    try {
      final doc = await _firestore.doc(_docPath).get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return AulaStudio.fromJson(data); // fornito da @freezed
    } catch (e) {
      print('Errore durante il fetch della disponibilità: $e');
      return null;
    }
  }
  /* implementazione senza freezed, deprecata
  Future<void> setDisponibilita(int nuovaDisponibilita) async {
    try {
      await _firestore.doc(_docPath).set({
        'disponibilita': nuovaDisponibilita,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Errore durante l\'aggiornamento della disponibilità: $e');
    }
  }
  */
  Future<void> setDisponibilita(int nuovaDisponibilita) async {
  try {
    final nuovoStato = AulaStudio(disponibilita: nuovaDisponibilita);
    await _firestore.doc(_docPath).set(nuovoStato.toJson()); // fornito da @freezed
  } catch (e) {
    print('Errore durante l\'aggiornamento della disponibilità: $e');
  }
}
  // utilizzare questo metodo per leggere le modifiche in tempo reale
  Stream<AulaStudio> disponibilitaStream() {
    return _firestore.doc(_docPath).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return const AulaStudio(disponibilita: 0);
      }
      return AulaStudio.fromJson(data); // fornito da @freezed
    });
  }
   Future<void> decrementaDisponibilita() async {
    try {
      await _firestore.doc(_docPath).update({
        'disponibilita': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Errore durante il decremento della disponibilità: $e');
    }
}

  Future<void> incrementaDisponibilita() async {
    try {
      await _firestore.doc(_docPath).update({
        'disponibilita': FieldValue.increment(1),
      });
    } catch (e) {
      print('Errore durante l\'incremento della disponibilità: $e');
    }
  } // TODO
}
