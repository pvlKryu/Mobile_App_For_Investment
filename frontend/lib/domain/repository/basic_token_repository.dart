import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const basicToken = 'basic-token';
}

// Хранение токена:
class BasicTokenRepository {
  final _secureStorage = const FlutterSecureStorage();

// Получение токена:
  Future<String?> getBasicToken() => _secureStorage.read(key: _Keys.basicToken);

// Запись токена:
  Future<void> setBasicToken(String value) => _secureStorage.write(key: _Keys.basicToken, value: value);

  Future<void> clearSecureStorage() =>  _secureStorage.deleteAll();
}
