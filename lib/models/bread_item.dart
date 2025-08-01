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
        BreadItem(name: 'じゃがバタ', inStock: true, imagePath: 'assets/images/Group 13.png'),
        BreadItem(name: '明太フランス', inStock: true, imagePath: 'assets/images/Group 17.png'),
        BreadItem(name: 'チョコクロ', inStock: true, imagePath: 'assets/images/Group 18.png'),
        BreadItem(name: 'フレンチトースト', inStock: true, imagePath: 'assets/images/Group 34.png'),
        BreadItem(name: 'ドッグ', inStock: true, imagePath: 'assets/images/Group 39.png'),
        BreadItem(name: 'デニッシュ', inStock: true, imagePath: 'assets/images/Group 1222.png'),
        BreadItem(name: 'その他', inStock: true, imagePath: 'assets/images/Group 45.png'),
      ];
}
