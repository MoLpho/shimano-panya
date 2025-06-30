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
    BreadItem(name: 'じゃがばたデニッシュ', inStock: true, imagePath: 'assets/images/Group 13.png'),
    BreadItem(name: '明太フランス', inStock: true, imagePath: 'assets/images/Group 17.png'),
    BreadItem(name: 'チョコクロワッサン', inStock: true, imagePath: 'assets/images/Group 18.png'),
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
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 商品画像
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: item.inStock ? Colors.green : Colors.grey,
                width: 2,
              ),
            ),
            child: _buildProductImage(item.imagePath, isInStock: item.inStock),
          ),
          const SizedBox(height: 8),
          // 商品名
          Text(
            item.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: item.inStock ? Colors.black87 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          // 在庫ステータス
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: item.inStock ? Colors.green[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item.inStock ? '在庫あり' : '売り切れ',
              style: TextStyle(
                color: item.inStock ? Colors.green[800] : Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ヘッダーウィジェット
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '現在のパン在庫',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '更新: $_lastUpdated',
            style: TextStyle(
              fontSize: 14,
              color: Colors.brown[700],
              fontWeight: FontWeight.w500,
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
          appBar: AppBar(
            title: const Text('パン屋さん'),
            backgroundColor: Colors.orange[300],
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _updateTime,
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/背景画像.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.white.withOpacity(0.7),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    // 商品グリッド
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