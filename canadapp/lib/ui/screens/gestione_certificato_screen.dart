import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canadapp/ui/viewmodels/gestione_certificato_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child:
                    viewModel.certificatoUrl != null
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await launchUrl(
                                      Uri.parse(viewModel.certificatoUrl!),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Impossibile aprire il certificato',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.description,
                                  size: 64,
                                  color: Color(0xFF1E88E5),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Certificato caricato',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Scadenza: ${viewModel.dataScadenzaString}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[600],
                                ),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Elimina Certificato',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: viewModel.deleteCertificate,
                              ),
                            ],
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              "Carica il tuo certificato medico",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Seleziona file'),
                              onPressed: () async {
                                final result = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'pdf',
                                        'jpg',
                                        'jpeg',
                                        'png',
                                      ],
                                    );
                                if (result != null) {
                                  viewModel.setFile(
                                    File(result.files.single.path!),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Data di scadenza',
                                prefixIcon: Icon(Icons.calendar_today),
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
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text('Carica Certificato'),
                              onPressed: viewModel.uploadCertificate,
                            ),
                          ],
                        ),
              ),
    );
  }
}
