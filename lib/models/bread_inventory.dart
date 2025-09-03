class BreadInventory {
  final Map<String, int> reliableCounts;
  final int reliableTotal;
  final DateTime timestamp;

  BreadInventory({
    required this.reliableCounts,
    required this.reliableTotal,
    required this.timestamp,
  });

  factory BreadInventory.fromJson(Map<String, dynamic> json) {
    try {
      return BreadInventory(
        reliableCounts: Map<String, int>.from(
          json['reliable']?['counts'] ?? {},
        ),
        reliableTotal: json['reliable']?['total'] ?? 0,
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
