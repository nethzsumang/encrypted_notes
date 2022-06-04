import 'dart:async';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  bool hasSetupAccount = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: 'k1');

    if (encryptionKey != null) {
      hasSetupAccount = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasSetupAccount == false) {
      GoRouter.of(context).push('/');
    }

    return Scaffold(
      body: const Text('Hello'),
      appBar: AppBar(title: const Text('Encrypted Notes')),
    );
  }
  
}