import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

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
        fontFamily: 'Alpen',
        primarySwatch: Colors.orange,
      ),
      home: const SplashScreen(),
    );
  }
}

/// パン商品のデータモデル
class BreadItem {
  final String name;
  final int quantity;
  final String imagePath;

  const BreadItem({
    required this.name,
    required this.quantity,
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
    BreadItem(name: 'じゃがばたデニッシュ', quantity: 12, imagePath: 'assets/images/Group 13.png'),
    BreadItem(name: '明太パン', quantity: 5, imagePath: 'assets/images/Group 17.png'),
    BreadItem(name: 'チョコクロワッサン', quantity: 0, imagePath: 'assets/images/Group 18.png'),
    BreadItem(name: 'フレンチトースト', quantity: 8, imagePath: 'assets/images/Group 34.png'),
    BreadItem(name: 'ソーセージ', quantity: 3, imagePath: 'assets/images/Group 39.png'),
    BreadItem(name: 'フランスパン', quantity: 15, imagePath: 'assets/images/Group 1222.png'),
    BreadItem(name: 'その他', quantity: 7, imagePath: 'assets/images/Group 45.png'),
  ];

  bool _showSplash = false;
  bool _isImagesPrecached = false;

  @override
  void initState() {
    super.initState();
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

  /// 商品画像ウィジェット（在庫有無による変化なし）
  Widget _buildProductImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 70,
      height: 70,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.bakery_dining,
        size: 40,
        color: Colors.orange[700],
      ),
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

  /// 商品カードウィジェット
  Widget _buildProductCard(BreadItem item) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFF9ECD5),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 商品画像
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: _buildProductImage(item.imagePath),
          ),
          const SizedBox(height: 8),
          // 商品名
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          // 在庫数表示
          Text(
            '残り: ${item.quantity}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // メインコンテンツ
        Scaffold(
          body: Stack(
            children: [
              // 背景画像を画面全体に
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/背景画像.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 白の半透明背景を画面全体に
              Container(
                color: Colors.white.withValues(alpha: 0.2),
              ),

              // SafeAreaでコンテンツだけ包む
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'いまのパン',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF78610),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final screenHeight = constraints.maxHeight;
                            final itemHeight = 180.0;
                            final maxVisibleItems = math.min(
                              _breadItems.length,
                              (screenHeight ~/ itemHeight * 2).clamp(4, 8),
                            );

                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 160,
                              ),
                              itemCount: maxVisibleItems,
                              itemBuilder: (context, index) => _buildProductCard(_breadItems[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // スプラッシュ画面
        if (_showSplash)
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/splash.png',
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
      MaterialPageRoute(builder: (_) => const TimeDisplayScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
