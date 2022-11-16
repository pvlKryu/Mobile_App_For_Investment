// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Transaction {
  Future<bool> buyShare(
    String figi,
    int amount,
    String token,
  ) async {
    final url = Uri.parse("http://18.219.109.109:8080/transaction/buy");
    bool result = false;
    final parameters = <String, dynamic>{
      'figi': figi,
      'numberOfStock': amount,
    };
    try {
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: jsonEncode(parameters));
      // Сообщения в консоль для удобства отладки:
      // print("Покупка акции:");
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

  Future<bool> sellShare(
    String figi,
    int amount,
    String token,
  ) async {
    final url = Uri.parse("http://18.219.109.109:8080/transaction/sell");
    bool result = false;
    final parameters = <String, dynamic>{
      'figi': figi,
      'numberOfStock': amount,
    };
    try {
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: jsonEncode(parameters));
      // Сообщения в консоль для удобства отладки:
      // print("Продажа акции:");
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
