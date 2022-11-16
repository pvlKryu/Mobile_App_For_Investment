import 'dart:convert';
import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey()
  int id;
  String name;
  String email;
  double balance;

  User({
    required this.id,
    required this.name,
    required this.balance,
    required this.email,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    double? balance,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        balance: balance ?? this.balance,
      );

  factory User.fromJson(Map<String, dynamic> jsonData) {
    // Если баланса = 0, то сервер вовзращает 0, а не 0.0:
    // Нужно проверить тип данных
    if (jsonData['balance'].runtimeType == int) {
      jsonData['balance'] = jsonData['balance'].toDouble();
    }
    return User(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
      balance: jsonData['balance'],
    );
  }

  static Map<String, dynamic> toMap(User model) => {
        'id': model.id,
        'name': model.name,
        'email': model.email,
        'balance': model.balance,
      };

  static String serialize(User model) => json.encode(User.toMap(model));

  static User deserialize(dynamic json) => User.fromJson(json);
}
