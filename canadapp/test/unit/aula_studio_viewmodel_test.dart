import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canadapp/ui/viewmodels/aula_studio_view_model.dart';
import 'package:canadapp/data/repositories/aula_studio_repository.dart';
import 'package:canadapp/data/repositories/user_repository.dart';
import 'package:canadapp/domain/models/aula_studio.dart';

// Sovrascrivi tutti i metodi che causano problemi, in particolare mockito non gestisce bene quelli con ritorno di tipo Stream o future
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

void main() {
  late MockAulaStudioRepository mockAulaStudioRepository;
  late MockUserRepository mockUserRepository;
  late AulaStudioViewModel viewModel;

  setUp(() {
    mockAulaStudioRepository = MockAulaStudioRepository();
    mockUserRepository = MockUserRepository();

    print('Mock creato: ${mockAulaStudioRepository.runtimeType}');
    
    // Non serve più when() per disponibilitaStream, è già implementato
    
    print('Creando ViewModel...');
    
    try {
      viewModel = AulaStudioViewModel(mockAulaStudioRepository, mockUserRepository);
      print('ViewModel creato con successo');
    } catch (e) {
      print('Errore nella creazione del ViewModel: $e');
      rethrow;
    }
  });

  tearDown(() {
    mockAulaStudioRepository.dispose();
  });
    
// Test per il metodo handleQrCodeScanned per verificare che al momento della scansione del QR code, 
//il metodo incrementaDisponibilita e setStudy vengano chiamati correttamente quando qrState è true
  test('handleQrCodeScanned - decrementa disponibilità quando qrState è false', () async {
    SharedPreferences.setMockInitialValues({'qrState': false, 'userId': 'testUser'});

    when(mockAulaStudioRepository.decrementaDisponibilita())
        .thenAnswer((_) async => {});
    when(mockUserRepository.setStudy('testUser', false))
        .thenAnswer((_) async => {});

    await viewModel.handleQrCodeScanned('qrCode123');

    verify(mockAulaStudioRepository.decrementaDisponibilita()).called(1);
    verify(mockUserRepository.setStudy('testUser', true)).called(1);
  });
}