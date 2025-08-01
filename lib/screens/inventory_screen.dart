import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bread_provider.dart';
import '../models/bread_inventory.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    // 画面が初期化された時に在庫情報を取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInventory();
    });
  }

  Future<void> _loadInventory() async {
    final provider = Provider.of<BreadProvider>(context, listen: false);
    await provider.fetchInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('パン在庫状況'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInventory,
          ),
        ],
      ),
      body: Consumer<BreadProvider>(
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
                  Text(provider.error!), // エラーメッセージを表示
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
    );
  }

  Widget _buildInventoryList(BreadInventory inventory) {
    final breadLabels = BreadInventory.getBreadLabels();
    final counts = inventory.reliableCounts;

    return ListView.builder(
      itemCount: breadLabels.length,
      itemBuilder: (context, index) {
        final breadId = breadLabels.keys.elementAt(index);
        final breadName = breadLabels[breadId]!;
        final count = counts[breadId] ?? 0;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(breadName),
            trailing: Text(
              '$count個',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: count > 0 ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
