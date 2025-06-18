import 'package:canadapp/ui/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canadapp/ui/screens/gestione_certificato_screen.dart';
import 'package:canadapp/ui/screens/login_screen.dart';
import 'package:canadapp/ui/screens/qr_scanner_screen.dart';
import 'package:canadapp/ui/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/aula_studio_view_model.dart';

class AulaStudioScreen extends StatelessWidget {
  const AulaStudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aulaStudioViewModel = context.watch<AulaStudioViewModel>();
    final disponibilita = aulaStudioViewModel.stato?.disponibilita ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Text(
              'Posti disponibili: $disponibilita',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF1E88E5),
              onPressed: () async {
                final scannedCode = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => QrScannerScreen(onCodeScanned: (code) {}),
                  ),
                );
                if (scannedCode != null) {
                  // Passa al ViewModel per aggiornare la disponibilità
                  aulaStudioViewModel.handleQrCodeScanned(scannedCode);
                }
              },
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
