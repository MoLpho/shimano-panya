import 'package:flutter/material.dart';
import 'dart:async';

// アプリケーションのエントリーポイント
void main() {
  runApp(const MyApp());
}

/// アプリケーションのルートウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SplashScreen(),
    );
  }
}

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
}

/// メインの在庫表示画面
class TimeDisplayScreen extends StatefulWidget {
  const TimeDisplayScreen({super.key});
  
  @override
  _TimeDisplayScreenState createState() => _TimeDisplayScreenState();
}

class _TimeDisplayScreenState extends State<TimeDisplayScreen> {
  static const List<BreadItem> _breadItems = [
    BreadItem(name: 'じゃがバタ', inStock: true, imagePath: 'assets/images/Group 13.png'),
    BreadItem(name: '明太フランス', inStock: true, imagePath: 'assets/images/Group 17.png'),
    BreadItem(name: 'チョコクロ', inStock: true, imagePath: 'assets/images/Group 18.png'),
    BreadItem(name: 'フレンチトースト', inStock: true, imagePath: 'assets/images/Group 34.png'),
    BreadItem(name: 'ドッグ', inStock: true, imagePath: 'assets/images/Group 39.png'),
    BreadItem(name: 'フランスパン', inStock: true, imagePath: 'assets/images/Group 1222.png'),
    BreadItem(name: 'その他', inStock: true, imagePath: 'assets/images/Group 45.png'),
  ];

  String _lastUpdated = '';
  bool _showSplash = false;
  bool _isImagesPrecached = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isImagesPrecached) {
      _preloadImages();
      _isImagesPrecached = true;
    }
  }

  /// 画像を事前に読み込む
  void _preloadImages() {
    for (final item in _breadItems) {
      try {
        precacheImage(AssetImage(item.imagePath), context);
      } catch (e) {
        debugPrint('画像の読み込みに失敗しました: ${item.imagePath}');
        debugPrint('エラー: $e');
      }
    }
  }

  /// 商品画像を表示するウィジェット
  Widget _buildProductImage(String imagePath, {required bool isInStock}) {
    final imageWidget = Image.asset(
      imagePath,
      width: 70,
      height: 70,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.bakery_dining,
        size: 40,
        color: isInStock ? Colors.orange[700] : Colors.grey,
      ),
    );

    return isInStock
        ? imageWidget
        : ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: imageWidget,
          );
  }

  /// スプラッシュ画面を表示する
  Future<void> _showSplashScreen() async {
    if (!mounted) return;
    
    setState(() => _showSplash = true);
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _showSplash = false);
    }
  }

  /// 最終更新時刻を更新する
  Future<void> _updateTime() async {
    await _showSplashScreen();
    
    if (!mounted) return;
    
    final now = DateTime.now();
    setState(() {
      _lastUpdated = '${now.month}月${now.day}日 ${now.hour}時${now.minute}分';
    });
  }

  /// 商品カードウィジェット
  Widget _buildProductCard(BreadItem item) {
    return Container(
      // 外側の枠（さらに薄い茶色）
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF9ECD5), // 外側の枠線をF9ECD5に変更
          width: 1.0, // 線を細くする
        ),
        // 外側と内側の枠の間を白で埋める
        color: const Color(0xFFFFFFFF), // 白に変更
      ),
      // 外側の余白を調整
      padding: const EdgeInsets.all(6), // 外側の余白を少し減らす
      child: Container(
        // 中側の枠（さらに薄い茶色）
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // 角丸を少し大きく
          border: Border.all(
            color: const Color(0xFFF9ECD5), // 内側の枠線もF9ECD5に統一
            width: 1.0, // 線を細くする
          ),
          // 内側の背景色
          color: const Color(0xFFFFFDF9), // 内側の背景色をFFFDF9に変更
        ),
        // 内側のマージンを設定してコンテンツを小さく
        margin: const EdgeInsets.all(4), // 内側の余白を少し減らす
        child: Container(
          width: 150, // カードの幅を少し狭める
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), // パディングを調整
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 商品画像（背景なし）
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildProductImage(item.imagePath, isInStock: item.inStock),
              ),
              const SizedBox(height: 6),  // 余白を少し減らす
              // 商品名
              SizedBox(
                width: double.infinity,
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: item.inStock ? Colors.brown[800] : Colors.grey[600],
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // 在庫数表示
              Text(
                '残り：${item.inStock ? '3' : '0'}個',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: item.inStock ? Colors.brown[800] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ヘッダーウィジェット（アプリバーに統合）
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 100,  // タイトルと更新時間を表示するために高さを調整
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.orange[700], size: 24),
              const SizedBox(width: 8),
              Text(
                'いまのパン',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.update, size: 14, color: Colors.orange[700]),
                const SizedBox(width: 6),
                Text(
                  '更新: $_lastUpdated',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 8.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
            onPressed: _updateTime,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景画像
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/背景画像.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // メインコンテンツ
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 商品グリッド
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.05,  // 高さを抑えるためにアスペクト比を調整
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _breadItems.length,
                      itemBuilder: (context, index) => _buildProductCard(_breadItems[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // スプラッシュ画面
        if (_showSplash)
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/panyaトップページ.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }
}

/// スプラッシュ画面
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  /// 3秒後にメイン画面に遷移
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TimeDisplayScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/panyaトップページ.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}