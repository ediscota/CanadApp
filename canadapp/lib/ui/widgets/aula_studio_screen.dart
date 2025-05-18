import 'package:flutter/material.dart';

class AulaStudioScreen extends StatelessWidget {
  const AulaStudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Posti disponibili: n/m',
              style: TextStyle(
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
              onPressed: () {
                // Azione bottone fotocamera
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
