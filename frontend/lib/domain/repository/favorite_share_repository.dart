// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/share.dart';
import 'basic_token_repository.dart';

class FavoriteSharesRepository {
  late final StreamController<List<Share>> _controller;
  final _basicTokenProvider = BasicTokenRepository();

  FavoriteSharesRepository()
      : _controller = StreamController<List<Share>>.broadcast() {
    getFavoritesShares().then((value) {
      _controller.add(value);
    });
  }

  Stream<List<Share>> get stream => _controller.stream;

  Future<List<Share>> getFavoritesShares() async {
    final url = Uri.parse("http://atb-api.ru:8080/stocks/favourite");
    Future<String?> stringFuture = _basicTokenProvider.getBasicToken();
    String? token = await stringFuture;
    token = token.toString();
    try {
      final response = await http.get(url, headers: <String, String>{
        // Передаем полученный токен в заголовке:
        'Authorization': token,
        'Content-Type': 'application/json',
      });
      final parsed = jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>();
      print("Получение избранных акций юзера:");
      print("Response status: ${response.statusCode}");
      return parsed.map<Share>((json) => Share.fromJson(json)).toList();
    } catch (error) {
      print("Error - $error");
      return [];
    }
  }
}