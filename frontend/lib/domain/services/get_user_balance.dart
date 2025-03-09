// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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
