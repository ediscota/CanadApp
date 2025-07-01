import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:canadapp/data/repositories/aula_studio_repository.dart';
import 'package:canadapp/domain/models/aula_studio.dart';

// Sovrascrivi tutti i metodi che causano problemi, in particolare mockito non gestisce bene quelli con ritorno di tipo Stream o Future
class MockAulaStudioRepository extends Mock implements AulaStudioRepository {

  //controller da uilizzare nei file di test per simulare il comportamento dei metodi mockati
  final StreamController<AulaStudio> _controller = StreamController<AulaStudio>();

  MockAulaStudioRepository() {
    // Inizializza il controller con un valore di default
    _controller.add(const AulaStudio(disponibilita: 0));
  }
 StreamController<AulaStudio> get controller => _controller;

  @override
  Stream<AulaStudio> disponibilitaStream() => _controller.stream;

  // Mock dei metodi che restituiscono Future con noSuchMethod per risposta generica
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

