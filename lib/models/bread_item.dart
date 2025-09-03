/// パン商品のデータモデル
class BreadItem {
  final String name;
  final bool inStock;
  final String imagePath;
  final int count;

  const BreadItem({
    required this.name,
    required this.inStock,
    required this.imagePath,
    required this.count,
  });
  /// デフォルトのパン商品リストを取得
  static List<BreadItem> get defaultBreadItems => [
  BreadItem(name: 'じゃがバタ', inStock: true, imagePath: 'assets/images/jagabata.png', count: 0),
  BreadItem(name: '明太フランス', inStock: true, imagePath: 'assets/images/mentai', count: 0),
  BreadItem(name: 'チョコクロ', inStock: true, imagePath: 'assets/images/choco_croissant', count: 0),
  BreadItem(name: 'フレンチトースト', inStock: true, imagePath: 'assets/images/french.png', count: 0),
  BreadItem(name: 'ドッグ', inStock: true, imagePath: 'assets/images/sausage.png', count: 0),
  BreadItem(name: 'デニッシュ', inStock: true, imagePath: 'assets/images/batadeni.png', count: 0),
  BreadItem(name: 'その他', inStock: true, imagePath: 'assets/images/Group 45.png', count: 0),
  ];
}
