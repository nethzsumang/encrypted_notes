import 'package:encrypted_notes/app/libraries/encryption_library.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(EncryptionLibrary().generateKeys('admin'));
    return const Text('Hello, World!');
  }

}