import 'dart:async';

import 'package:encrypted_notes/app/store/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  bool hasSetupAccount = true;

  @override
  void afterFirstLayout(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: 'k1');
    String? userNo = await secureStorage.read(key: 'userNo');

    if (encryptionKey == null || userNo == null) {
      hasSetupAccount = false;
      return;
    }

    // fetch notes
  }

  @override
  Widget build(BuildContext context) {
    if (hasSetupAccount == false) {
      GoRouter.of(context).push('/');
    }

    return Scaffold(
      body: const Text('Hello'),
      appBar: AppBar(title: const Text('Encrypted Notes')),
      drawer: BlocBuilder<NotesBloc, List>(
        builder: (context, notes) {
          return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Encrypted Notes'),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    onTap: () {},
                  ),
                ],
              )
          );
        },
      )
    );
  }
  
}