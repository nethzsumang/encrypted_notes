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
  @override
  void afterFirstLayout(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: 'k1');
    String? iv = await secureStorage.read(key: 'iv');
    String? k3 = await secureStorage.read(key: 'k3');
    String? salt = await secureStorage.read(key: 'salt');

    if (encryptionKey == null || iv == null || k3 == null || salt == null) {
      showWelcomeDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Hello, World!');
  }

  void showWelcomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: 'Welcome!',
        width: 300,
        height: 300,
        children: const [
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                  'It seems that you haven\'t set up yet. Please select one of these buttons to continue.'
              )
          )
        ]
      )
    );
  }
}
