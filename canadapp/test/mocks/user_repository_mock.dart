import 'package:canadapp/data/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {
  @override
  Future<void> setStudy(String userId, bool isStudying) => super.noSuchMethod(
    Invocation.method(#setStudy, [userId, isStudying]),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );
}