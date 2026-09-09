import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code/main.dart'; // for AppColors, AppBackground, GlassCard

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});
  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController urlController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();
  String qrData = '';

  Future<void> _shareQrCode() async {
    if (qrData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate a QR code first')),
      );
      return;
    }
    try {
      RenderRepaintBoundary boundary =
      _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Here is my QR code');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share QR code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Link')),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (qrData.isEmpty) ...[
                  const Text(
                    'Generate Code',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter your data below to create a QR code.',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Enter your data',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: urlController,
                    maxLines: 5,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: const InputDecoration(
                      hintText: 'https://example.com or any text',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (urlController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter some data first')),
                        );
                        return;
                      }
                      setState(() {
                        qrData = urlController.text.trim();
                      });
                    },
                    icon: const Icon(Icons.qr_code_2_rounded),
                    label: const Text('Generate QR Code'),
                  ),
                ] else ...[
                  const Text(
                    'Generated Code',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your QR code is ready to share or save.',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  GlassCard(
                    radius: 20,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        RepaintBoundary(
                          key: _qrKey,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: QrImageView(data: qrData, size: 200),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ENCODED DATA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGrey,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.glassFillStrong,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            qrData,
                            style: const TextStyle(color: AppColors.textDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareQrCode,
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Share'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareQrCode, // uses same share sheet; user can pick "Save"
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        qrData = '';
                        urlController.clear();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Generate New'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}