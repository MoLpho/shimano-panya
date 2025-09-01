import 'package:flutter/material.dart';
import '../models/bread_item.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';
import '../constants/app_dimens.dart';

/// メインの在庫表示画面
class TimeDisplayScreen extends StatefulWidget {
  const TimeDisplayScreen({super.key});
  
  @override
  _TimeDisplayScreenState createState() => _TimeDisplayScreenState();
}

class _TimeDisplayScreenState extends State<TimeDisplayScreen> {
  late List<BreadItem> _breadItems;
  String _lastUpdated = '';
  bool _showSplash = false;
  bool _isImagesPrecached = false;

  @override
  void initState() {
    super.initState();
    _breadItems = BreadItem.defaultBreadItems;
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
        final image = AssetImage(item.imagePath);
        precacheImage(image, context);
        // エラーハンドリング用にロードを試みる
        image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (image, synchronousCall) {},
            onError: (exception, StackTrace? stackTrace) {
              debugPrint('画像の読み込みに失敗しました: ${item.imagePath}');
              debugPrint('エラー: $exception');
            },
          ),
        );
      } catch (e) {
        debugPrint('画像のプリロード中にエラーが発生しました: ${item.imagePath}');
        debugPrint('エラー: $e');
      }
    }
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
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // メインコンテンツ
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            lastUpdated: _lastUpdated,
            onRefresh: _updateTime,
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/背景画像.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingLarge,
                vertical: AppDimens.paddingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 商品グリッド
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: AppDimens.paddingLarge),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: AppDimens.gridCrossAxisCount,
                        childAspectRatio: AppDimens.gridChildAspectRatio,
                        crossAxisSpacing: AppDimens.gridCrossAxisSpacing,
                        mainAxisSpacing: AppDimens.gridMainAxisSpacing,
                      ),
                      itemCount: _breadItems.length,
                      itemBuilder: (context, index) => ProductCard(
                        item: _breadItems[index],
                      ),
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
