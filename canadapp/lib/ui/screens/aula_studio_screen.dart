import 'package:canadapp/ui/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/aula_studio_view_model.dart';

class AulaStudioScreen extends StatefulWidget {
  const AulaStudioScreen({super.key});

  @override
  State<AulaStudioScreen> createState() => _AulaStudioScreenState();
}

class _AulaStudioScreenState extends State<AulaStudioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAnimation(bool shouldBlink) {
    if (shouldBlink) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0; // Rende il widget completamente visibile
    }
  }

  @override
  Widget build(BuildContext context) {
    final aulaStudioViewModel = context.watch<AulaStudioViewModel>();
    final disponibilita = aulaStudioViewModel.stato?.disponibilita ?? 0;
    final shouldBlink = aulaStudioViewModel.qrState;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimation(shouldBlink);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity:
                  shouldBlink ? _opacityAnimation : AlwaysStoppedAnimation(1.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color(0xFFE3F2FD),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 30,
                  ),
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
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
