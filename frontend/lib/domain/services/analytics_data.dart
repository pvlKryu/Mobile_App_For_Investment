// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:async';

class AnalyticsData {
  Future<double> getAnalyticsBalanceData(
      String typeOfOperation, String token) async {
    final url = Uri.parse(
        "http://atb-api.ru:8080/client/balance/history?typeOfOperation=$typeOfOperation");
    double data = 0;
    try {
      var response = await http.get(url, headers: <String, String>{
        // Передаем полученную хеш-строку в заголовке:
        'Authorization': token,
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        dynamic responseBody = response.body;
        data = double.parse(responseBody);
      }

      return data;
    } catch (error) {
      print("Error - $error");
      return data;
    }
  }

  Future<double> getCurrencyIncomeData(String token) async {
    final url = Uri.parse("http://18.219.109.109:8080/client/income");
    double income = 1;
    try {
      var response = await http.get(url, headers: <String, String>{
        // Передаем полученную хеш-строку в заголовке:
        'Authorization': token,
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        dynamic responseBody = response.body;
        income = double.parse(responseBody);
      }
      // print("Получение дохода в рублях");
      // print(income);
      return income;
    } catch (error) {
      print("Error - $error");
      return income;
    }
  }

  Future<double> getAbsoluteIncomeData(String token) async {
    final url = Uri.parse("http://18.219.109.109:8080/client/percentageIncome");
    double income = 1;
    try {
      var response = await http.get(url, headers: <String, String>{
        // Передаем полученную хеш-строку в заголовке:
        'Authorization': token,
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        dynamic responseBody = response.body;
        income = double.parse(responseBody);
      }
      // print("Получение дохода в %");
      // print(income);
      return income;
    } catch (error) {
      print("Error - $error");
      return income;
    }
  }
}
