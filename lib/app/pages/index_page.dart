import 'package:after_layout/after_layout.dart';
import 'package:encrypted_notes/app/components/index/login_form.dart';
import 'package:encrypted_notes/app/store/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int currentStep = 0;

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
    if (hasSetupAccount) {
      GoRouter.of(context).go('/home');
    }

    return BlocProvider(
      create: (BuildContext context) => AuthBloc(),
      child: const Scaffold(
          body: LoginForm()
      )
    );
  }
}
