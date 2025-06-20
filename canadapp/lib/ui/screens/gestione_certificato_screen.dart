import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canadapp/ui/viewmodels/gestione_certificato_view_model.dart';
import 'package:file_picker/file_picker.dart';

class GestioneCertificatoScreen extends StatefulWidget {
  const GestioneCertificatoScreen({super.key});

  @override
  State<GestioneCertificatoScreen> createState() =>
      _GestioneCertificatoScreenState();
}

class _GestioneCertificatoScreenState extends State<GestioneCertificatoScreen> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GestioneCertificatoViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
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
      body: Center(
        child:
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : viewModel.certificatoUrl != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scadenza: ${viewModel.dataScadenzaString}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.deleteCertificate,
                      child: const Text('Elimina Certificato'),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Carica il tuo certificato medico",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                        );
                        if (result != null) {
                          viewModel.setFile(File(result.files.single.path!));
                        }
                      },
                      child: const Text('Seleziona file'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Data di scadenza',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 5),
                          ),
                        );
                        if (picked != null) {
                          viewModel.setDataScadenza(picked);
                          _dateController.text =
                              '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.uploadCertificate,
                      child: const Text('Carica Certificato'),
                    ),
                  ],
                ),
      ),
    );
  }
}
