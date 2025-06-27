import 'package:canadapp/ui/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color(0xFFE3F2FD), // Azzurro molto chiaro
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.event_seat,
                      size: 60,
                      color: Color(0xFF1E88E5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Posti disponibili',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Text(
                        '$disponibilita',
                        key: ValueKey<int>(disponibilita),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
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
                print(scannedCode);
                if (scannedCode != null) {
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
