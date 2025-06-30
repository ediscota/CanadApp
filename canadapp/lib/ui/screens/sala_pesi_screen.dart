import 'dart:async';

import 'package:canadapp/domain/models/prenotazione.dart';
import 'package:canadapp/ui/core/calendar_bottom_sheet.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalaPesiScreen extends StatefulWidget {
  const SalaPesiScreen({super.key});

  @override
  State<SalaPesiScreen> createState() => _SalaPesiScreenState();
}

class _SalaPesiScreenState extends State<SalaPesiScreen> {
  Timer? _errorTimer;

  Future<bool> isCertificatoValid() async {
    final salaPesiViewModel = context.read<SalaPesiViewModel>();
    final res = await salaPesiViewModel.isCertificatoValid();
    print(res);
    return res;
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
    List<Prenotazione> items = salaPesiViewModel.userPrenotazioni();
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
        child: FutureBuilder(
          future: isCertificatoValid(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return Column(
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
                            children:
                                errors
                                    .map(
                                      (error) => Text(
                                        error,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
                  // LISTA PRENOTAZIONI
                  Expanded(
                    child: ListView.builder(
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
                              '${item.data}   ${item.ora}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder:
                                    (context) => SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Data: ${item.data}\nOra: ${item.ora}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            Center(
                                              child: QrImageView(
                                                data: item.id,
                                                version: QrVersions.auto,
                                                size: 200.0,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text('Chiudi'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        foregroundColor:
                                                            Colors.black,
                                                      ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await salaPesiViewModel
                                                        .eliminaPrenotazione(
                                                          item.id,
                                                        );
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Elimina'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ), // Piccolo margine per sicurezza
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
                ],
              );
            } else {
              return Text('Certificato assente o scaduto');
            }
          },
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: isCertificatoValid(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return FloatingActionButton(
              onPressed: () {
                showCalendarBottomSheet(context);
              },
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.add, color: Colors.white),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
