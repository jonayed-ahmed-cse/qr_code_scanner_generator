import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_code/main.dart'; // for AppColors
import 'package:qr_code/scan_history_model.dart';
import 'package:qr_code/history_service.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});
  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  String qrResult = '';
  bool get hasResult => qrResult.isNotEmpty;

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

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: qrResult));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  Future<void> _shareResult() async {
    await Share.share(qrResult);
  }

  Future<void> _webSearch() async {
    Uri uri;
    final isUrl = qrResult.startsWith('http://') || qrResult.startsWith('https://');
    if (isUrl) {
      uri = Uri.parse(qrResult);
    } else {
      uri = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent(qrResult)}');
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  Widget _actionIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textDark, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Link')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              if (hasResult)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      Text(
                        qrResult,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionIcon(icon: Icons.search, label: 'Search', onTap: _webSearch),
                          _actionIcon(icon: Icons.share_outlined, label: 'Share', onTap: _shareResult),
                          _actionIcon(icon: Icons.copy_outlined, label: 'Copy', onTap: _copyToClipboard),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: const [
                    Icon(Icons.qr_code_scanner_rounded, size: 64, color: AppColors.textGrey),
                    SizedBox(height: 16),
                    Text(
                      'Scanned data will appear here',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 15),
                    ),
                  ],
                ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: scanQR,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(hasResult ? 'Scan Again' : 'Scan Code'),
              ),
              const SizedBox(height: 24),
            ],
          ),
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
  bool _hasScanned = false;

  Future<void> _handleDetected(String code) async {
    // Prevent double-triggering while we're saving.
    _hasScanned = true;

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = await HistoryService.saveQrImage(code, id);
      await HistoryService.addHistory(
        ScanHistoryItem(
          id: id,
          imagePath: imagePath,
          data: code,
          scannedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      // Even if saving to history fails, don't block returning the result.
    }

    if (!mounted) return;
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_hasScanned) return;
          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final code = barcodes.first.rawValue;
            if (code != null) {
              _handleDetected(code);
            }
          }
        },
      ),
    );
  }
}