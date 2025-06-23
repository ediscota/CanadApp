import 'package:canadapp/ui/screens/calendar_bottom_sheet.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalaPesiScreen extends StatefulWidget {
  const SalaPesiScreen({super.key});

  @override
  State<SalaPesiScreen> createState() => _SalaPesiScreenState();
}

class _SalaPesiScreenState extends State<SalaPesiScreen> {
  @override
  Widget build(BuildContext context) {
    final salaPesiViewModel = context.watch<SalaPesiViewModel>();
    final items = salaPesiViewModel.prenotazioni;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(
                Icons.perm_contact_calendar,
                size: 32,
                color: Color(0xFF1E88E5),
              ),
              title: Text(
                item.userId,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.dataOra.toString()),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    height: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.userId,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.dataOra.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Chiudi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCalendarBottomSheet(context);
        },
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
