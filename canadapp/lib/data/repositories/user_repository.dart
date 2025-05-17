import '../../domain/models/user.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<User?> login(String email, String password) {
    return _service.login(email, password);
  }
}