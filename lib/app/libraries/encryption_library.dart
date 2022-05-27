import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:password_hash_plus/password_hash_plus.dart';

class EncryptionLibrary {
  String generateRandomString(int len) {
    Random.secure();
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  generateKeys(String password) {
    var iv = IV.fromUtf8(generateRandomString(16));
    var salt = String.fromCharCodes(Salt.generate(16));
    String k1 = generateRandomString(128);

    PBKDF2 generator = PBKDF2();
    Uint8List pbkdf2 = Uint8List.fromList(generator.generateKey(password, salt, 1000, 256));
    List<int> k2 = pbkdf2.sublist(0, 128);
    List<int> k3 = pbkdf2.sublist(128, 256);
    Key encrypterKey = Key.fromBase64(base64Encode(k2));
    print(encrypterKey.length);

    final encrypter = Encrypter(AES(encrypterKey, mode: AESMode.sic));
    var encryptedK1 = encrypter.encrypt(k1, iv: iv);

    return {
      k1: encryptedK1.base64,
      iv: iv.base64,
      k3: Key.fromBase64(base64Encode(k3)).base64,
      salt: salt
    };
  }
}