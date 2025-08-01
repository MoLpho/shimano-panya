import 'package:flutter/foundation.dart';
import '../models/bread_inventory.dart';
import '../services/bread_service.dart';

class BreadProvider with ChangeNotifier {
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
