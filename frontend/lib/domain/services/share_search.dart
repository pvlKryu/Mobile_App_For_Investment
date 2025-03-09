// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:async';

import '../repository/basic_token_repository.dart';

class ShareSearch {
  final _basicTokenProvider = BasicTokenRepository();
  Future<bool> searchShare(String name) async {
    final url = Uri.parse("http://atb-api.ru:8080/stocks/name/$name");
    bool result = false;
    Future<String?> stringFuture = _basicTokenProvider.getBasicToken();
    String? token = await stringFuture;
    token = token.toString();

    try {
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token,
      });
      // Сообщения в консоль для удобства отладки:
      print("Поиск акции:");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      // Если все ок:
      if (response.statusCode == 200) {
        result = true;
      }
      return result;
    } catch (error) {
      // Ловим ошибку:
      print("Error - $error");
      return result;
    }
  }
}
