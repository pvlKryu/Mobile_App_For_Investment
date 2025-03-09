// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:firstflutterproj/domain/models/operation.dart';
import 'package:http/http.dart' as http;
import '../models/operation.dart';
import 'basic_token_repository.dart';

class UserOperationsRepository {
  late final StreamController<List<Operation>> _controller;
  final _basicTokenProvider = BasicTokenRepository();

  UserOperationsRepository()
      : _controller = StreamController<List<Operation>>.broadcast() {
    getUserShares().then((value) {
      _controller.add(value);
    });
  }

  Stream<List<Operation>> get stream => _controller.stream;

  Future<List<Operation>> getUserShares() async {
    final url =
        Uri.parse("http://atb-api.ru:8080/transaction/historyOfOperations");
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
      print("Получение акций юзера:");
      print("Response status: ${response.statusCode}");
      return parsed.map<Operation>((json) => Operation.fromJson(json)).toList();
    } catch (error) {
      print("Error - $error");
      return [];
    }
  }
}
