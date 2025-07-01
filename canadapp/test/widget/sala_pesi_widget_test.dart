import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'package:canadapp/ui/screens/sala_pesi_screen.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';
import 'mocks_generated/sala_pesi_mock.mocks.dart';// File generato da mockito 


void main() {
  testWidgets('Mostra messaggio quando certificato non valido', (WidgetTester tester) async {
    final mockViewModel = MockSalaPesiViewModel();
    when(mockViewModel.isCertificatoValid()).thenAnswer((_) async => false);
    when(mockViewModel.userPrenotazioni()).thenReturn([]);
    when(mockViewModel.errors).thenReturn([]);
    when(mockViewModel.isLoading).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<SalaPesiViewModel>.value(
          value: mockViewModel,
          child: const SalaPesiScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Certificato assente o scaduto'), findsOneWidget);
  });
}