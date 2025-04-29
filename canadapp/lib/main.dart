import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test prova 200', //
      home: FirebaseTestScreen(),
    );
  }
}

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  _FirebaseTestScreenState createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String? _result;

  Future<void> _testFirestore() async {
    try {
      // Aggiunge un documento nella collezione "test"
      await FirebaseFirestore.instance.collection('test').add({
        'timestamp': DateTime.now(),
        'message': 'Prova connessione riuscita!',
      });

      setState(() {
        _result = "✅ Connessione a Firebase riuscita!";
      });
    } catch (e) {
      setState(() {
        _result = "❌ Errore: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _testFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Firebase")),
      body: Center(child: Text(_result ?? "Test in corso...")),
    );
  }
}
