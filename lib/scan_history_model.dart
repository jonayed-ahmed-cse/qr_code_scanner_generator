class ScanHistoryItem {
  final String id;
  final String imagePath;
  final String data;
  final DateTime scannedAt;

  ScanHistoryItem({
    required this.id,
    required this.imagePath,
    required this.data,
    required this.scannedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'data': data,
    'scannedAt': scannedAt.toIso8601String(),
  };

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) =>
      ScanHistoryItem(
        id: json['id'] as String,
        imagePath: json['imagePath'] as String,
        data: json['data'] as String,
        scannedAt: DateTime.parse(json['scannedAt'] as String),
      );
}