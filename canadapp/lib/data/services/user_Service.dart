import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .where('password', isEqualTo: password)
              .limit(1)
              .get();
      if (query.docs.isEmpty) return null;
      final doc = query.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return User.fromJson(data);
    } catch (e) {
      //log errore
      return null;
    }
  }

  Future<void> setStudy(String userId, bool study) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isStudy': study,
      });
    } catch (e) {
      //log errore
    }
  }
}
