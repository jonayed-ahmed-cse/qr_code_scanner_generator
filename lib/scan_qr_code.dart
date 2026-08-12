import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});
  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  String qrResult = 'Scanned data will appear here';

  Future<void> scanQR() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const _QrScannerPage()),
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        qrResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Scanner',
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(qrResult, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: scanQR, child: const Text('Scan Code')),
          ],
        ),
      ),
    );
  }
}

class _QrScannerPage extends StatefulWidget {
  const _QrScannerPage();

  @override
  State<_QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<_QrScannerPage> {
  bool _hasScanned = false; // guard flag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_hasScanned) return; // ignore repeat frames

          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final code = barcodes.first.rawValue;
            if (code != null) {
              _hasScanned = true; // lock immediately
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
