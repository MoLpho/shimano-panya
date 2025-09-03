import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import '../constants/app_colors.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800; // 800px以上ならPC想定

    return Scaffold(
      backgroundColor: isWide ? AppColors.background : null, // PCは背景色
      body: Stack(
        children: [
          // スマホの場合は画像を表示
          !isWide ? 
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.cover,
              ),
            ) : Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
