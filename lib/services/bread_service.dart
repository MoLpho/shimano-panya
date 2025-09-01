import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';
import '../models/bread_inventory.dart';

class BreadService {
  static const String _baseUrl = 'https://yolo.panyasonic.net/api';
  static const String _endpoint = '/bread-count/both';

  BreadService() {
    if (kIsWeb) {
      print('Running on Web platform.');
    } else {
      print('Platform version: ${Platform.version}');
    }
  }

  // HttpClientの取得
  http.Client _getHttpClient() {
    if (kIsWeb) {
      // Web環境では通常のhttp.Clientを使用
      return http.Client();
    } else {
      // ネイティブ環境ではカスタムHttpClientを使用
      final httpClient = HttpClient();
      // 証明書の検証をスキップ（開発用のみ）
      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return IOClient(httpClient);
    }
  }

  Future<BreadInventory> fetchBreadInventory() async {
    print('Fetching bread inventory from: $_baseUrl$_endpoint');
    final client = _getHttpClient();

    try {
      final response = await client.get(
        Uri.parse('$_baseUrl$_endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
          final inventory = BreadInventory.fromJson(data);
          print('Successfully parsed inventory: $inventory');
          return inventory;
        } catch (e) {
          print('Error parsing response: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception('Failed to load bread inventory. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchBreadInventory: $e');
      throw Exception('Network request failed: $e');
    } finally {
      client.close();
    }
  }
}
