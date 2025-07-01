import 'package:canadapp/ui/screens/aula_studio_screen.dart';
import 'package:canadapp/ui/screens/gestione_certificato_screen.dart';
import 'package:canadapp/ui/screens/sala_pesi_screen.dart';
import 'package:canadapp/ui/viewmodels/home_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeScreenViewModel>();
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
            onSelected: (String value) async {
              if (value == 'certificato') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GestioneCertificatoScreen(),
                  ),
                );
              } else if (value == 'logout') {
                viewModel.logout(context); // ritorno al login
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
      body:
          (viewModel.selectedIndex == 0)
              ? const AulaStudioScreen()
              : const SalaPesiScreen(),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          currentIndex: viewModel.selectedIndex,
          onTap: viewModel.onItemTapped,
          backgroundColor: Color(0xFFF5EDF7),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.book),
              label: 'AULA STUDIO',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center),
              label: 'SALA PESI',
            ),
          ],
        ),
      ),
    );
  }
}
