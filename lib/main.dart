import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';
import 'providers/bread_provider.dart';

// アプリケーションのエントリーポイント
void main() {
  runApp(const MyApp());
}

/// アプリケーションのルートウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BreadProvider()),
      ],
      child: MaterialApp(
        title: 'ぱにゃそにっく',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
