import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:password_hash_plus/password_hash_plus.dart';

class EncryptionLibrary {
  // Generate Random String
  // Generates a random alphanumeric string with [len] length.
  String generateRandomString(int len) {
    Random.secure();
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  // Generate keys
  // This function generate keys from random iv, salt and keys.
  // This returns a base64 encoded encrypted k1, base64 encoded iv used in encryption,
  // base64 encoded k3 for password verification and the salt used in PBKDF2 algo.
  generateKeys(String password) {
    var iv = IV.fromUtf8(generateRandomString(16));
    var salt = String.fromCharCodes(Salt.generate(16));
    String k1 = generateRandomString(128);

    PBKDF2 generator = PBKDF2();
    Uint8List pbkdf2 = Uint8List.fromList(generator.generateKey(password, salt, 1000, 32));
    List<int> k2 = pbkdf2.sublist(0, 16);
    List<int> k3 = pbkdf2.sublist(16, 32);
    Key encrypterKey = Key.fromBase64(base64Encode(k2));
    print(encrypterKey.length);

    final encrypter = Encrypter(AES(encrypterKey, mode: AESMode.cbc));
    var encryptedK1 = encrypter.encrypt(k1, iv: iv);

    return {
      'k1': encryptedK1.base64,
      'iv': iv.base64,
      'k3': Key.fromBase64(base64Encode(k3)).base64,
      'salt': salt
    };
  }

  // Get Encrypt Key From password
  // Generates a alphanumeric key from [password], [salt], a base64 encoded [iv],
  // a base64 encoded [encryptedK1]. The base64 encoded [k3] is to check if the
  // supplied [password] is correct and valid.
  getEncryptKeyFromPassword(String password, String salt, String iv, String encryptedK1, String k3) {
    // generate PBKDF2 string using supplied salt and password
    PBKDF2 generator = PBKDF2();
    Uint8List pbkdf2 = Uint8List.fromList(generator.generateKey(password, salt, 1000, 32));
    List<int> k2 = pbkdf2.sublist(0, 16);
    List<int> generatedK3 = pbkdf2.sublist(16, 32);

    // check if k3 generated here is same to the k3 passed here
    // if not, password is wrong
    // since, supplied k3 is base64 encoded, let's decode it first then convert to string
    k3 = String.fromCharCodes(base64Decode(k3));
    // let's convert the generated k3 to string
    String generatedK3String = String.fromCharCodes(generatedK3);
    if (generatedK3String != k3) {
      return null;
    }

    // decrypt the encrypted k1 using k2
    Key encrypterKey = Key.fromBase64(base64Encode(k2));
    final encrypter = Encrypter(AES(encrypterKey, mode: AESMode.cbc));
    return encrypter.decrypt(Encrypted.fromBase64(encryptedK1), iv: IV.fromBase64(iv));
  }

  // Encrypt content
  // This function encrypts [content] with base64 encoded [key] and base64 encoded [iv].
  // It returns an encrypted string.
  encryptContent(String content, String key, String encodedIv) {
    Key encrypterKey = Key.fromBase64(key);
    IV iv = IV.fromBase64(encodedIv);

    final encrypter = Encrypter(AES(encrypterKey, mode: AESMode.cbc));
    return encrypter.encrypt(content, iv: iv);
  }

  // Decrypt content
  // This function decrypts [encryptedContent] with base64 encoded [key] and
  // base64 encoded [iv]
  decryptContent(String encryptedContent, String key, String encodedIv) {
    Key encrypterKey = Key.fromBase64(key);
    IV iv = IV.fromBase64(encodedIv);
    Encrypted encrypted = Encrypted.fromUtf8(encryptedContent);

    final encrypter = Encrypter(AES(encrypterKey, mode: AESMode.cbc));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}