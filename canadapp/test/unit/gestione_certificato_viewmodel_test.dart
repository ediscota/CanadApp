import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:canadapp/ui/viewmodels/gestione_certificato_view_model.dart';
import 'mocks_generated/gestione_certificato_repository_mock.mocks.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GestioneCertificatoViewModel viewModel;
  late MockGestioneCertificatoRepository mockRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'userId': 'TestUser'});
    mockRepository = MockGestioneCertificatoRepository();
    //_loadCertificatoDati();
    when(
      mockRepository.fetchCertificate('TestUser'),
    ).thenAnswer((_) async => {'dataScadenza': null});
    viewModel = GestioneCertificatoViewModel(mockRepository);
    await Future.delayed(Duration.zero);
  });

  test('isValidForm ritorna false se file o data mancano', () {
    expect(viewModel.isValidForm, false);

    viewModel.setFile(File('test.pdf'));
    expect(viewModel.isValidForm, false);

    viewModel.setDataScadenza('2025-07-20');
    expect(viewModel.isValidForm, true);
  });

  test(
    'uploadCertificate chiama il repository se i dati sono validi',
    () async {
      viewModel.setFile(File('dummy.pdf'));
      viewModel.setDataScadenza('2025-07-20');

      when(
        mockRepository.uploadCertificate(any, any, any),
      ).thenAnswer((_) async {});

      await viewModel.uploadCertificate('2025-07-20');

      verify(mockRepository.uploadCertificate(any, any, any)).called(1);
      expect(viewModel.certificatoCaricato, true);
      expect(viewModel.isLoading, false);
    },
  );

  test('setFile e setDataScadenza aggiornano lo stato', () {
    viewModel.setFile(File('cert.pdf'));
    expect(viewModel.fileSelezionato, isNotNull);

    viewModel.setDataScadenza('2025-12-31');
    expect(viewModel.dataScadenza, '2025-12-31');
  });

  test('getCertificatoUrl ritorna URL dal repository', () async {
    when(
      mockRepository.getCertificatoUrl('TestUser'),
    ).thenAnswer((_) async => 'https://example.com/cert.pdf');

    final url = await viewModel.getCertificatoUrl();
    expect(url, 'https://example.com/cert.pdf');
  });
}
