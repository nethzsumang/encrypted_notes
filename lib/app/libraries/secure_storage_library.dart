import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageLibrary {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  getValue(String key) async {
    return await storage.read(key: key);
  }

  setValue(String key, value) async {
    await storage.write(key: key, value: value);
  }
}