import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'scan_history_model.dart';

class HistoryService {
  static const _key = 'scan_history';

  /// Returns history sorted newest-first.
  static Future<List<ScanHistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final items = raw
        .map((e) => ScanHistoryItem.fromJson(
        jsonDecode(e) as Map<String, dynamic>))
        .toList();
    items.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return items;
  }

  static Future<void> addHistory(ScanHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(item.toJson()));
    await prefs.setStringList(_key, raw);
  }

  static Future<void> deleteItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final remaining = raw.where((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return json['id'] != id;
    }).toList();
    await prefs.setStringList(_key, remaining);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Generates a QR image PNG from [data] and saves it to the app's
  /// documents directory. Returns the saved file path.
  /// (We regenerate the QR from the decoded text instead of trying to
  /// capture the live camera frame — it's simpler and always crisp.)
  static Future<String> saveQrImage(String data, String id) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
    );
    final ByteData? byteData = await painter.toImageData(300);
    final bytes = byteData!.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/qr_history_$id.png');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}