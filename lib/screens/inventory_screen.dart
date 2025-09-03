import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/bread_provider.dart';
import '../models/bread_inventory.dart';
import '../widgets/product_card.dart';
import '../models/bread_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    // 画面が初期化された時に在庫情報を取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInventory();
      // 5秒ごとに個数だけ静かに更新
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        final provider = Provider.of<BreadProvider>(context, listen: false);
        await provider.refreshCountsOnly();
      });
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadInventory() async {
    final provider = Provider.of<BreadProvider>(context, listen: false);
    await provider.fetchInventory();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800; // 800px以上ならPC想定

    return Scaffold(
      body: Stack(
        children: [
          // 背景
          Positioned.fill(
            child: !isWide
              ? Image.asset(
                // スマホ用背景（縦長イラスト）
                'assets/images/background.png',
                fit: BoxFit.cover,
              )
              : const SizedBox.shrink(), // PC時は何も表示せず Scaffold 背景色が見える
          ),

          // コンテンツ
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Consumer<BreadProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('エラーが発生しました'),
                            Text(provider.error!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadInventory,
                              child: const Text('再読み込み'),
                            ),
                          ],
                        ),
                      );
                    }

                    final inventory = provider.inventory;
                    if (inventory == null) {
                      return const Center(child: Text('データがありません'));
                    }

                    return _buildInventoryList(inventory);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(BreadInventory inventory) {
    final breadLabels = BreadInventory.getBreadLabels();
    final counts = inventory.reliableCounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'いまのパン',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // 1カードの最大幅
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: breadLabels.length,
            itemBuilder: (context, index) {
              final breadId = breadLabels.keys.elementAt(index);
              final breadName = breadLabels[breadId]!;
              final count = counts[breadId] ?? 0;

              final item = BreadItem(
                name: breadName,
                inStock: count > 0,
                imagePath: 'assets/images/${breadId}.png',
              );

              return ProductCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}
