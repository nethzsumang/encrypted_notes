import 'package:after_layout/after_layout.dart';
import 'package:encrypted_notes/app/libraries/encryption_library.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    if (hasSetupAccount) {
      GoRouter.of(context).go('/home');
    }
    return Scaffold(
       body: SizedBox(
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username'
                  ),
                )
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password'
                  ),
                  obscureText: true,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: TextButton(
                    onPressed: () { },
                    child: const Text('Login')
                  ),
                )
              )
            ]
          ),
      )
    );
  }
}
