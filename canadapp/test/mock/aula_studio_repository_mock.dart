import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:canadapp/data/repositories/aula_studio_repository.dart';
import 'package:canadapp/data/repositories/user_repository.dart';
import 'package:canadapp/domain/models/aula_studio.dart';

// Sovrascrivi tutti i metodi che causano problemi, in particolare mockito non gestisce bene quelli con ritorno di tipo Stream o Future
class MockAulaStudioRepository extends Mock implements AulaStudioRepository {
  final StreamController<AulaStudio> _controller = StreamController<AulaStudio>();
  
  @override
  Stream<AulaStudio> disponibilitaStream() => _controller.stream;
  
  @override
  Future<void> decrementaDisponibilita() => super.noSuchMethod(
    Invocation.method(#decrementaDisponibilita, []),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );

  @override
  Future<void> incrementaDisponibilita() => super.noSuchMethod(
    Invocation.method(#incrementaDisponibilita, []),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );
  
  void dispose() {
    _controller.close();
  }
}

class MockUserRepository extends Mock implements UserRepository {
  @override
  Future<void> setStudy(String userId, bool isStudying) => super.noSuchMethod(
    Invocation.method(#setStudy, [userId, isStudying]),
    returnValue: Future<void>.value(),
    returnValueForMissingStub: Future<void>.value(),
  );
}