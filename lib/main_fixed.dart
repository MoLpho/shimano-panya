import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    BreadItem(name: 'クロワッサン', inStock: true, imagePath: 'assets/croissant.png'),
    BreadItem(name: 'メロンパン', inStock: true, imagePath: 'assets/melonpan.png'),
    BreadItem(name: 'あんぱん', inStock: false, imagePath: 'assets/anpan.png'),
    BreadItem(name: '食パン', inStock: true, imagePath: 'assets/shokupan.png'),
    BreadItem(name: 'チョココロネ', inStock: true, imagePath: 'assets/chocorone.png'),
    BreadItem(name: 'フランスパン', inStock: true, imagePath: 'assets/french_bread.png'),
    BreadItem(name: 'クリームパン', inStock: false, imagePath: 'assets/cream_pan.png'),
    BreadItem(name: 'レーズンパン', inStock: true, imagePath: 'assets/raisin_bread.png'),
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              '現在のパン在庫',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '更新: $_lastUpdated',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
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
                          color: item.inStock ? Colors.green[50] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
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
                              child: Icon(
                                Icons.bakery_dining,
                                size: 40,
                                color: item.inStock ? Colors.orange[700] : Colors.grey,
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
