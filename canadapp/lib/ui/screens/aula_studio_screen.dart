import 'package:canadapp/ui/screens/gestione_certificato_screen.dart';
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5), // Colore blu
        title: const Text(
          'CanadApp',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0)),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ), //Icona utente in alto a destra
            onSelected: (String value) {
              if (value == 'certificato') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GestioneCertificatoScreen(),
                  ),
                );
              } else if (value == 'logout') {
                // TODO: implementa la logica di logout
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ); // ritorno al login
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    value: 'certificato',
                    child: Text('Gestione Certificato'),
                  ),
                  PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
          ),
        ],
      ),
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
            bottom: 80,
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFFF5EDF7),
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.tablet_mac),
                    SizedBox(height: 4),
                    Text('AULA STUDIO'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFEDE4F5),
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.fitness_center),
                    SizedBox(height: 4),
                    Text('SALA PESI'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
