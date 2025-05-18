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
      return AulaStudio.fromJson(data);
    } catch (e) {
      print('Errore durante il fetch della disponibilità: $e');
      return null;
    }
  }
  Future<void> setDisponibilita(int nuovaDisponibilita) async {
    try {
      await _firestore.doc(_docPath).set({
        'disponibilita': nuovaDisponibilita,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Errore durante l\'aggiornamento della disponibilità: $e');
    }
  }
  // utilizzare questo metodo per ascoltare le modifiche in tempo reale
  Stream<AulaStudio> disponibilitaStream() {
    return _firestore.doc(_docPath).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return const AulaStudio(disponibilita: 0);
      }
      return AulaStudio.fromJson(data);
    });
  }
  
}
