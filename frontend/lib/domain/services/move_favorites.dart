// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MoveFavorites {
  Future<bool> addFavorites(
    String figi,
    String token,
  ) async {
    final url = Uri.parse("http://18.219.109.109:8080/stocks/favourite");
    bool result = false;
    final parameters = <String, dynamic>{
      'figi': figi,
    };
    try {
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: jsonEncode(parameters));
      // Сообщения в консоль для удобства отладки:
      // print("Добавление избранной акции:");
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");
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

  Future<bool> deleteFavorites(
    String figi,
    String token,
  ) async {
    final url = Uri.parse("http://18.219.109.109:8080/stocks/favourite");
    bool result = false;
    final parameters = <String, dynamic>{
      'figi': figi,
    };
    try {
      final response = await http.delete(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: jsonEncode(parameters));
      // Сообщения в консоль для удобства отладки:
      // print("Удаление избранной акции:");
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");
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
