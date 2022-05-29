import 'package:after_layout/after_layout.dart';
import 'package:encrypted_notes/app/components/reusable/custom_dialog.dart';
import 'package:encrypted_notes/app/libraries/encryption_library.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> with AfterLayoutMixin<IndexPage> {
  bool hasSetupAccount = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: 'k1');
    String? iv = await secureStorage.read(key: 'iv');
    String? k3 = await secureStorage.read(key: 'k3');
    String? salt = await secureStorage.read(key: 'salt');

    if (encryptionKey != null && iv != null && k3 != null && salt != null) {
      hasSetupAccount = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Hello, World!');
  }

}
