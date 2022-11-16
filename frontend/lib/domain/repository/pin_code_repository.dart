import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const pinCode = 'pin-code';
}

class PinCodeRepository {
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getPinCode() => _secureStorage.read(key: _Keys.pinCode);

  Future<void> setPinCode(String value) =>
      _secureStorage.write(key: _Keys.pinCode, value: value);
}
