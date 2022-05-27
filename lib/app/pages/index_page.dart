import 'package:encrypted_notes/app/libraries/encryption_library.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var response = EncryptionLibrary().generateKeys('admin');
    var k1 = EncryptionLibrary().getEncryptKeyFromPassword('admin', response['salt'], response['iv'], response['k1'], response['k3']);
    var plainstr = 'Lorem ipsum dolor sit amet consectetur elit, adespescing elit.';
    var encrypted = EncryptionLibrary().encryptContent(plainstr, k1, response['iv']);
    var decrypted = EncryptionLibrary().decryptContent(encrypted, k1, response['iv']);
    print('Plain String: ' + plainstr);
    print('Encrypted: ' + encrypted);
    print('Decrypted: ' + decrypted);
    return const Text('Hello, World!');
  }

}