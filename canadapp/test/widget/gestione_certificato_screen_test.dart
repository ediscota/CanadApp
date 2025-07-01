import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:canadapp/ui/screens/gestione_certificato_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:canadapp/ui/viewmodels/gestione_certificato_view_model.dart';
import 'mocks_generated/gestione_certificato_mock.mocks.dart';

void main() {
  late MockGestioneCertificatoViewModel viewModel;

  setUp(() {
    viewModel = MockGestioneCertificatoViewModel();
  });

  testWidgets('Il bottone carica è disabilitato se il form non è valido', (
    WidgetTester tester,
  ) async {
    when(viewModel.isLoading).thenReturn(false);
    when(viewModel.isValidForm).thenReturn(false);
    when(viewModel.certificatoCaricato).thenReturn(false);

    await tester.pumpWidget(
      ChangeNotifierProvider<GestioneCertificatoViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: GestioneCertificatoScreen()),
      ),
    );

    expect(find.byKey(const Key('caricaCertificatoButton')), findsOneWidget);
    final ElevatedButton button = tester.widget(
      find.byKey(const Key('caricaCertificatoButton')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Il bottone carica è abilitato se il form è valido', (
    WidgetTester tester,
  ) async {
    when(viewModel.isLoading).thenReturn(false);
    when(viewModel.isValidForm).thenReturn(true);
    when(viewModel.certificatoCaricato).thenReturn(false);

    await tester.pumpWidget(
      ChangeNotifierProvider<GestioneCertificatoViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: GestioneCertificatoScreen()),
      ),
    );

    await tester.pump();

    final ElevatedButton button = tester.widget(
      find.byKey(const Key('caricaCertificatoButton')),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Dopo il caricamento appare la sezione "Certificato caricato"', (
    WidgetTester tester,
  ) async {
    when(viewModel.isLoading).thenReturn(false);
    when(viewModel.certificatoCaricato).thenReturn(true);
    when(viewModel.dataScadenzaString).thenReturn('2025-07-15');
    when(
      viewModel.getCertificatoUrl(),
    ).thenAnswer((_) async => 'https://example.com/cert.pdf');

    await tester.pumpWidget(
      ChangeNotifierProvider<GestioneCertificatoViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: GestioneCertificatoScreen()),
      ),
    );

    expect(find.byKey(const Key('certificatoCaricatoSection')), findsOneWidget);
    expect(find.text('Certificato caricato'), findsOneWidget);
  });
}
