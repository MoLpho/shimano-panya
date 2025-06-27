import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class TimeDisplayScreen extends StatefulWidget {
  @override
  _TimeDisplayScreenState createState() => _TimeDisplayScreenState();
}

class BreadItem {
  final String name;
  final bool inStock;
  final String imagePath;

  BreadItem({required this.name, required this.inStock, required this.imagePath});
}

class _TimeDisplayScreenState extends State<TimeDisplayScreen> {
  String _lastUpdated = '';
  final List<BreadItem> _breadItems = [
    BreadItem(name: 'じゃがばたデニッシュ', inStock: true, imagePath: 'assets/images/Group 13.png'),
    BreadItem(name: '明太フランス', inStock: true, imagePath: 'assets/images/Group 17.png'),
    BreadItem(name: 'チョコクロワッサン', inStock: true, imagePath: 'assets/images/Group 18.png'),
    BreadItem(name: 'フレンチトースト', inStock: true, imagePath: 'assets/images/Group 34.png'),
    BreadItem(name: 'ドッグ', inStock: true, imagePath: 'assets/images/Group 39.png'),
    BreadItem(name: 'フランスパン', inStock: true, imagePath: 'assets/images/Group 1222.png'),
    BreadItem(name: 'その他', inStock: true, imagePath: 'assets/images/Group 45.png'),
  ];

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

  // 画像をプリロードする
  void _preloadImages() {
    for (var item in _breadItems) {
      try {
        precacheImage(AssetImage(item.imagePath), context);
      } catch (e) {
        print('Failed to load image: ${item.imagePath}');
        print('Error: $e');
      }
    }
  }

  Widget _buildImageWidget(String imagePath, {required bool isInStock}) {
    return isInStock
        ? Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.bakery_dining,
                size: 40,
                color: Colors.orange[700],
              );
            },
          )
        : ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: Image.asset(
              imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.bakery_dining,
                  size: 40,
                  color: Colors.grey,
                );
              },
            ),
          );
  }


  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _lastUpdated = '${now.month}月${now.day}日 ${now.hour}時${now.minute}分';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('パン屋さん'),
        backgroundColor: Colors.orange[300],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _updateTime,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/背景画像.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.7), // 半透明の白いオーバーレイ
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
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
                      SizedBox(height: 5),
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
                ),
                SizedBox(height: 20),
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
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 160,
                        ),
                        itemCount: maxVisibleItems,
                        itemBuilder: (context, index) {
                          final item = _breadItems[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                  child: item.inStock
                                      ? Image.asset(
                                          item.imagePath,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.contain,
                                        )
                                      : ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Image.asset(
                                            item.imagePath,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: item.inStock ? Colors.black87 : Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: TimeDisplayScreen(),
  ));
}
