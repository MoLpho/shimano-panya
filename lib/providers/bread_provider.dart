import 'package:flutter/foundation.dart';
import '../models/bread_inventory.dart';
import '../services/bread_service.dart';

class BreadProvider with ChangeNotifier {
  // 在庫数だけ静かに更新
  Future<void> refreshCountsOnly() async {
    try {
      final newInventory = await _breadService.fetchBreadInventory();
      if (_inventory != null) {
        _inventory = BreadInventory(
          reliableCounts: newInventory.reliableCounts,
          reliableTotal: newInventory.reliableTotal,
          timestamp: newInventory.timestamp,
        );
      } else {
        _inventory = newInventory;
      }
      notifyListeners();
    } catch (e) {
      // エラー無視
    }
  }
  final BreadService _breadService = BreadService();
  BreadInventory? _inventory;
  bool _isLoading = false;
  String? _error;

  BreadInventory? get inventory => _inventory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchInventory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _inventory = await _breadService.fetchBreadInventory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 在庫数を更新するメソッド
  void updateInventory(BreadInventory newInventory) {
    _inventory = newInventory;
    notifyListeners();
  }

  // エラーをリセットするメソッド
  void resetError() {
    _error = null;
    notifyListeners();
  }
}
