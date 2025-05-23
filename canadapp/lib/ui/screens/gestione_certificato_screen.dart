import 'dart:io';
import 'package:canadapp/ui/viewmodels/gestione_certificato_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GestioneCertificatoScreen extends StatelessWidget {
  const GestioneCertificatoScreen({Key? key}) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final viewModel = Provider.of<GestioneCertificatoViewModel>(
      context,
      listen: false,
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.dataScadenza ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      viewModel.setDataScadenza(picked);
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    final viewModel = Provider.of<GestioneCertificatoViewModel>(
      context,
      listen: false,
    );
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      viewModel.caricaCertificato(file);

      // SnackBar di conferma
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Certificato caricato: ${file.path.split('/').last}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<GestioneCertificatoViewModel>(
          builder: (context, viewModel, _) {
            final dateText =
                viewModel.dataScadenza != null
                    ? DateFormat('MM/dd/yyyy').format(viewModel.dataScadenza!)
                    : '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data di scadenza certificato",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(text: dateText),
                      decoration: InputDecoration(
                        labelText: 'Data',
                        hintText: 'mm/dd/yyyy',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _pickFile(context),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Carica certificato"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                if (viewModel.certificato != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    "File selezionato: ${viewModel.certificato!.path.split('/').last}",
                  ),
                ],
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final viewModel =
                          Provider.of<GestioneCertificatoViewModel>(
                            context,
                            listen: false,
                          );

                      try {
                        final userId =
                            FirebaseAuth
                                .instance
                                .currentUser
                                ?.uid; // prende l'ID dell'utente loggato
                        await viewModel.salvaSuFirestore(userId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Data salvata con successo"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Errore: ${e.toString()}")),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Salva"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
