import 'package:canadapp/ui/screens/aula_studio_screen.dart';
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
        toolbarHeight: 70,
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
          // child: Row(
          //   children: [
          //     Expanded(
          //       child: Container(
          //         color: const Color(0xFFF5EDF7),
          //         height: 70,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: const [
          //             Icon(Icons.book),
          //             SizedBox(height: 4),
          //             Text('AULA STUDIO'),
          //           ],
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         color: const Color(0xFFEDE4F5),
          //         height: 70,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: const [
          //             Icon(Icons.fitness_center),
          //             SizedBox(height: 4),
          //             Text('SALA PESI'),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
