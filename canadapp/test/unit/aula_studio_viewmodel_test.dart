import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canadapp/ui/viewmodels/aula_studio_view_model.dart';
import '../mock/aula_studio_repository_mock.dart';

void main() {
  late MockAulaStudioRepository mockAulaStudioRepository;
  late MockUserRepository mockUserRepository;
  late AulaStudioViewModel viewModel;

  setUp(() {
    mockAulaStudioRepository = MockAulaStudioRepository();
    mockUserRepository = MockUserRepository();

    print('Mock creato: ${mockAulaStudioRepository.runtimeType}');
    
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
  // il metodo decrementaDisponibilita e setStudy vengano chiamati correttamente quando qrState è false
  test('handleQrCodeScanned - decrementa disponibilità quando qrState è false', () async {
    SharedPreferences.setMockInitialValues({'qrState': false, 'userId': 'testUser'});

    when(mockAulaStudioRepository.decrementaDisponibilita())
        .thenAnswer((_) async => {});
    when(mockUserRepository.setStudy('testUser', true))
        .thenAnswer((_) async => {});

    await viewModel.handleQrCodeScanned('qrCode123');

    verify(mockAulaStudioRepository.decrementaDisponibilita()).called(1);
    verify(mockUserRepository.setStudy('testUser', true)).called(1);
  });

  // Test aggiuntivo per quando qrState è true (dovrebbe incrementare)
  test('handleQrCodeScanned - incrementa disponibilità quando qrState è true', () async {
    SharedPreferences.setMockInitialValues({'qrState': true, 'userId': 'testUser'});

    when(mockAulaStudioRepository.incrementaDisponibilita())
        .thenAnswer((_) async => {});
    when(mockUserRepository.setStudy('testUser', false))
        .thenAnswer((_) async => {});

    await viewModel.handleQrCodeScanned('qrCode123');

    verify(mockAulaStudioRepository.incrementaDisponibilita()).called(1);
    verify(mockUserRepository.setStudy('testUser', false)).called(1);
  });
}