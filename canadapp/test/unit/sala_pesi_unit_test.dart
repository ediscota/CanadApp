import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Importa il mock generato
import 'mocks_generated/sala_pesi_repository_mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SalaPesiViewModel - aggiungiPrenotazione', () {
    late MockSalaPesiRepository mockRepository;
    late SalaPesiViewModel viewModel;

    setUp(() {
      SharedPreferences.setMockInitialValues({'userId': 'testUserId'});
      mockRepository = MockSalaPesiRepository();
      viewModel = SalaPesiViewModel(mockRepository);
    });

    test('Popola errors se il certificato non è valido', () async {
      when(mockRepository.aggiungiPrenotazione(any, any)).thenAnswer((_) async => ['Utente non certificato o certificato scaduto.']);
      when(mockRepository.fetchPrenotazioni()).thenAnswer((_) async => []); 
      await viewModel.aggiungiPrenotazione('2025-07-01', '10:00');
      expect(viewModel.errors, contains('Utente non certificato o certificato scaduto.'));
    });
  });
}