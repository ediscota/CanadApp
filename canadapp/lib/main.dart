import 'package:canadapp/ui/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CanadApp());
}

class CanadApp extends StatelessWidget {
  const CanadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CanadApp',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
