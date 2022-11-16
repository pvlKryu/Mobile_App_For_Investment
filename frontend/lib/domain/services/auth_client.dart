// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/user.dart';

class AuthClient {
  Future<bool> userRegistration(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse("http://18.219.109.109:8080/client/registration");
    bool result = false;
    final parameters = <String, String>{
      'name': name,
      'email': email,
      'password': password,
    };
    try {
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(parameters));
      // Сообщения в консоль для удобства отладки:
      // print("Регистрация пользователя:");
      // print("Name - $name");
      // print("Email - $email");
      // print("Password - $password");
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

  // ignore: body_might_complete_normally_nullable
  Future<User?> userLogin(String token) async {
    {
      final url = Uri.parse("http://18.219.109.109:8080/client/profile");
      try {
        final response = await http.get(url, headers: <String, String>{
          // Передаем полученный токен в заголовке:
          'Authorization': token,
          'Content-Type': 'application/json',
        });
        // Сообщения в консоль для удобства отладки:
        // print("Авторизация пользователя:");
        // print("Response status: ${response.statusCode}");
        // print("Response body: ${response.body}");

        // Возвращаем пользователя
        if (response.body.isNotEmpty) {
          return User.fromJson(jsonDecode(response.body));
        }
      } catch (error) {
        // Ловим ошибку:
        print("Error - $error");
        return null;
      }
    }
  }

  Future<User?> changeUserData(
      String token, String name, String email, String password) async {
    {
      final parameters = <String, String>{
        'name': name,
        'email': email,
        'password': password,
      };
      final url = Uri.parse("http://18.219.109.109:8080/client/profile");

      try {
        final response = await http.put(url,
            headers: <String, String>{
              // Передаем полученный токен в заголовке:
              'Authorization': token,
              'Content-Type': 'application/json',
            },
            body: jsonEncode(parameters));
        // Сообщения в консоль для удобства отладки:
        // print("Изменение данных пользователя:");
        // print("Response status: ${response.statusCode}");
        // print("Response body: ${response.body}");

        // Возвращаем пользователя
        if (response.body.isNotEmpty) {
          return User.fromJson(jsonDecode(response.body));
        }
        return null; // ???
      } catch (error) {
        // Ловим ошибку:
        print("Error - $error");
        return null;
      }
    }
  }
}
