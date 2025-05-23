import 'package:canadapp/ui/screens/login_screen.dart';
import 'package:canadapp/ui/viewmodels/gestione_certificato_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'data/services/user_service.dart';
import 'data/repositories/user_repository.dart';
import 'ui/viewmodels/login_view_model.dart';
import 'data/services/aula_studio_service.dart';
import 'data/repositories/aula_studio_repository.dart';
import 'ui/viewmodels/aula_studio_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CanadApp());
}

class CanadApp extends StatelessWidget {
  const CanadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Service
        Provider(create: (_) => UserService()),
        Provider(create: (_) => AulaStudioService()),

        // Repository che dipende dal Service
        ProxyProvider<UserService, UserRepository>(
          update: (_, service, __) => UserRepository(service),
        ),
        ProxyProvider<AulaStudioService, AulaStudioRepository>(
          update: (_, service, __) => AulaStudioRepository(service),
        ),

        ChangeNotifierProvider(create: (_) => GestioneCertificatoViewModel()),

        // ViewModel che dipende dal Repository
        ChangeNotifierProxyProvider<UserRepository, LoginViewModel>(
          create: (_) => LoginViewModel(UserRepository(UserService())),
          update: (_, repo, __) => LoginViewModel(repo),
        ),
        ChangeNotifierProxyProvider<AulaStudioRepository, AulaStudioViewModel>(
          create:
              (_) => AulaStudioViewModel(
                AulaStudioRepository(AulaStudioService()),
              ),
          update: (_, repo, __) => AulaStudioViewModel(repo),
        ),
      ],
      child: MaterialApp(
        title: 'CanadApp',
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}
