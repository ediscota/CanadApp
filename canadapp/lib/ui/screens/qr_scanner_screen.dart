import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  final Function(String) onCodeScanned;
  const QrScannerScreen({Key? key, required this.onCodeScanned})
    : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner QR Code')),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) async {
          if (_hasScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            print(code);
            if (code == "CANADAPP") {
              _hasScanned = true;
              widget.onCodeScanned(code!);
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
