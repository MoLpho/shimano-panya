import 'package:flutter/material.dart';
import 'inventory_screen.dart';

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
      MaterialPageRoute(builder: (_) => const InventoryScreen()),
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
