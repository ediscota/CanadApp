import 'package:canadapp/domain/models/aula_studio.dart';
import 'package:canadapp/ui/screens/aula_studio_screen.dart';
import 'package:canadapp/ui/viewmodels/aula_studio_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../mocks/aula_studio_repository_mock.dart';
import '../mocks/user_repository_mock.dart';

void main() {
  late MockAulaStudioRepository mockAulaStudioRepository;
  late MockUserRepository mockUserRepository;
  late AulaStudioViewModel viewModel;
  setUp(() {
    mockAulaStudioRepository = MockAulaStudioRepository();
    mockUserRepository = MockUserRepository();
    try {
      viewModel = AulaStudioViewModel(mockAulaStudioRepository, mockUserRepository);
    } catch (e) {
      print('Errore nella creazione del ViewModel: $e');
      rethrow;
    }
  });

  tearDown(() {
    mockAulaStudioRepository.dispose();
  });

  testWidgets('Mostra il FloatingActionButton e permette il tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AulaStudioViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: AulaStudioScreen()),
      ),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  });

   testWidgets('Mostra correttamente la disponibilità', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AulaStudioViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: AulaStudioScreen()),
      ),
    );
    //utilizzo il controller per simulare il comportamento del metodo disponibilitaStream
    mockAulaStudioRepository.controller.add(const AulaStudio(disponibilita: 10));
    //aggiorna stato widget
    await tester.pump();
    expect(find.text('Posti disponibili'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });
  
}