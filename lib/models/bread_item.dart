/// パン商品のデータモデル
class BreadItem {
  final String name;
  final bool inStock;
  final String imagePath;

  const BreadItem({
    required this.name,
    required this.inStock,
    required this.imagePath,
  });
  /// デフォルトのパン商品リストを取得
  static List<BreadItem> get defaultBreadItems => [
    BreadItem(name: 'じゃがバタ', inStock: true, imagePath: 'assets/images/jagabata.png'),
    BreadItem(name: '明太フランス', inStock: true, imagePath: 'assets/images/mentai'),
    BreadItem(name: 'チョコクロ', inStock: true, imagePath: 'assets/images/choco_croissant'),
    BreadItem(name: 'フレンチトースト', inStock: true, imagePath: 'assets/images/french.png'),
    BreadItem(name: 'ドッグ', inStock: true, imagePath: 'assets/images/sausage.png'),
    BreadItem(name: 'デニッシュ', inStock: true, imagePath: 'assets/images/batadeni.png'),
    BreadItem(name: 'その他', inStock: true, imagePath: 'assets/images/Group 45.png'),
  ];
}
