// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class BalanceClient {
  // Запрос на получение баланса
  Future<double> getUserBalance(String basicAuth) async {
    final url = Uri.parse("http://atb-api.ru:8080/client/balance");

    double balance = 0;
    try {
      var response = await http.get(url, headers: <String, String>{
        // Передаем полученную хеш-строку в заголовке:
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      });
      // Сообщения в консоль для удобства отладки:
      print("Получение баланса пользователя:");
      print('Basic - $basicAuth');
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Если все ок:
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['balance'].runtimeType == int) {
          json['balance'] = json['balance'].toDouble();
        }
        balance = json['balance'];

        // print("Считываемый баланс: $balance");
      }

      return balance;
    } catch (error) {
      // Ловим ошибку:
      print("Error - $error");
      return balance;
    }
  }

  // Запрос на изменение баланса
  Future<bool> changeUserBalance(
    String type,
    double sum,
    String token,
  ) async {
    final url = Uri.parse("http://atb-api.ru:8080/client/balance");
    bool result = false;
    final parameters = <String, dynamic>{
      'typeOfOperation': type,
      'amount': sum,
    };
    try {
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: jsonEncode(parameters));
      print("Изменение баланса пользователя:");
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
