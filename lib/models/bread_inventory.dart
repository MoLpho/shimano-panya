class BreadInventory {
  final Map<String, int> realtimeCounts;
  final int realtimeTotal;
  final DateTime timestamp;

  BreadInventory({
    required this.realtimeCounts,
    required this.realtimeTotal,
    required this.timestamp,
  });

  factory BreadInventory.fromJson(Map<String, dynamic> json) {
    try {
      return BreadInventory(
        realtimeCounts: Map<String, int>.from(
          json['realtime']?['counts'] ?? {},
        ),
        realtimeTotal: json['realtime']?['total'] ?? 0,
        timestamp: json['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (json['timestamp'] * 1000).toInt(),
              )
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing BreadInventory: $e');
      rethrow;
    }
  }

  // パンごとの表示用ラベル
  static Map<String, String> getBreadLabels() {
    return {
      'choco_croissant': 'チョコクロワッサン',
      'batadeni': 'バターデニッシュ',
      'mentai': '明太パン',
      'jagabata': 'じゃがバタデニッシュ',
      'sausage': 'ソーセージ',
      'french': 'フレンチトースト',
    };
  }
}
