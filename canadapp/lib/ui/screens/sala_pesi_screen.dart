import 'dart:async';

import 'package:canadapp/ui/core/calendar_bottom_sheet.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SalaPesiScreen extends StatefulWidget {
  const SalaPesiScreen({super.key});

  @override
  State<SalaPesiScreen> createState() => _SalaPesiScreenState();
}



class _SalaPesiScreenState extends State<SalaPesiScreen> {
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalaPesiViewModel>().fetchPrenotazioni();
    });
}

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  void _startErrorTimer(SalaPesiViewModel viewModel) {
    _errorTimer?.cancel(); // Cancella eventuali timer già in corso
    _errorTimer = Timer(const Duration(seconds: 3), () {
      viewModel.clearErrors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final salaPesiViewModel = context.watch<SalaPesiViewModel>();
    final items = salaPesiViewModel.prenotazioni;
    final errors = salaPesiViewModel.errors;

    // Se ci sono errori, fai partire il timer per nasconderli dopo 3 secondi
    if (errors.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startErrorTimer(salaPesiViewModel);
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // SEZIONE ERRORI
            if (errors.isNotEmpty)
              AnimatedOpacity(
                opacity: errors.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Card(
                  color: Colors.red.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: errors
                          .map((error) => Text(
                                error,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            // LISTA PRENOTAZIONI
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'Nessuna prenotazione disponibile.',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 30,
                              // ignore: deprecated_member_use
                              backgroundColor: const Color(0xFF1E88E5).withOpacity(0.2),
                              child: const Icon(
                                Icons.fitness_center,
                                color: Color(0xFF1E88E5),
                                size: 30,
                              ),
                            ),
                            title: Text(
                              '${item.data}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.ora,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: const Icon(
                              Icons.qr_code_2,
                              size: 30,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) => SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Dettaglio Prenotazione',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Data: ${item.data}\nOra: ${item.ora}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        QrImageView(
                                          data: item.id,
                                          version: QrVersions.auto,
                                          size: 220.0,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey[300],
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: const Text('Chiudi'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await salaPesiViewModel.eliminaPrenotazione(item.id);
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: const Text('Elimina'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
          ],
        ),
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