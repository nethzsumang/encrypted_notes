import 'dart:async';

import 'package:encrypted_notes/app/components/home/note_list.dart';
import 'package:encrypted_notes/app/store/auth_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    if (hasSetupAccount == false) {
      GoRouter.of(context).push('/');
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AuthBloc()),
        BlocProvider(create: (BuildContext context) => NotesBloc())
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Encrypted Notes')),
        body: BlocBuilder<NotesBloc, List>(
          builder: (context, notes) {
            return const NoteList();
          }
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {},
          child: const Icon(Icons.note_add),
        ),
      )
    );
  }
}