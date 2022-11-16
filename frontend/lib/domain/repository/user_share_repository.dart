// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/share.dart';
import 'basic_token_repository.dart';

class UserSharesRepository {
  late final StreamController<List<Share>> _controller;
  final _basicTokenProvider = BasicTokenRepository();

  UserSharesRepository()
      : _controller = StreamController<List<Share>>.broadcast() {
    getUserShares().then((value) {
      _controller.add(value);
    });
  }

  Stream<List<Share>> get stream => _controller.stream;

  Future<List<Share>> getUserShares() async {
    final url = Uri.parse("http://18.219.109.109:8080/client/stocks");
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
      // print("Получение акций юзера:");
      // print("Response status: ${response.statusCode}");
      return parsed.map<Share>((json) => Share.fromJson(json)).toList();
    } catch (error) {
      print("Error - $error");
      return [];
    }
  }
}
