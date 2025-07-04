import 'package:canadapp/data/repositories/sala_pesi_repository.dart';
import 'package:canadapp/data/services/sala_pesi_service.dart';
import 'package:canadapp/ui/screens/login_screen.dart';
import 'package:canadapp/ui/viewmodels/home_screen_view_model.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:canadapp/data/repositories/gestione_certificato_repository.dart';
import 'package:canadapp/data/services/gestione_certificato_service.dart';
import 'package:canadapp/ui/viewmodels/gestione_certificato_view_model.dart';

import 'data/services/user_service.dart';
import 'data/repositories/user_repository.dart';
import 'ui/viewmodels/login_view_model.dart';
import 'data/services/aula_studio_service.dart';
import 'data/repositories/aula_studio_repository.dart';
import 'ui/viewmodels/aula_studio_view_model.dart';
import 'package:canadapp/data/services/notifiche_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Rome'));
  NotificheService().initializeNotification();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(CanadApp());
  });
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
        Provider(create: (_) => SalaPesiService()),
        Provider(create: (_) => GestioneCertificatoService()),

        // Repository che dipende dal Service
        ProxyProvider<UserService, UserRepository>(
          update: (_, service, __) => UserRepository(service),
        ),
        ProxyProvider<AulaStudioService, AulaStudioRepository>(
          update: (_, service, __) => AulaStudioRepository(service),
        ),
        ProxyProvider<SalaPesiService, SalaPesiRepository>(
          update: (_, service, __) => SalaPesiRepository(service),
        ),
        ProxyProvider<
          GestioneCertificatoService,
          GestioneCertificatoRepository
        >(update: (_, service, __) => GestioneCertificatoRepository(service)),

        // ViewModel che dipende dal Repository
        ChangeNotifierProxyProvider<UserRepository, LoginViewModel>(
          create: (_) => LoginViewModel(UserRepository(UserService())),
          update: (_, repo, __) => LoginViewModel(repo),
        ),
        ChangeNotifierProxyProvider2<
          AulaStudioRepository,
          UserRepository,
          AulaStudioViewModel
        >(
          create:
              (_) => AulaStudioViewModel(
                AulaStudioRepository(AulaStudioService()),
                UserRepository(UserService()),
              ),
          update:
              (_, aulaRepo, userRepo, __) =>
                  AulaStudioViewModel(aulaRepo, userRepo),
        ),
        ChangeNotifierProxyProvider(
          create: (_) => HomeScreenViewModel(),
          update: (_, _, _) => HomeScreenViewModel(),
        ),
        ChangeNotifierProxyProvider<SalaPesiRepository, SalaPesiViewModel>(
          create:
              (_) => SalaPesiViewModel(SalaPesiRepository(SalaPesiService())),
          update: (_, repo, __) => SalaPesiViewModel(repo),
        ),
        ChangeNotifierProxyProvider<
          GestioneCertificatoRepository,
          GestioneCertificatoViewModel
        >(
          create:
              (_) => GestioneCertificatoViewModel(
                GestioneCertificatoRepository(GestioneCertificatoService()),
              ),
          update: (_, repo, __) => GestioneCertificatoViewModel(repo),
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
