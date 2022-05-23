import 'package:flutter/material.dart';
import 'package:encrypted_notes/app/router/routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  static const title = 'Encrypted Notes';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routeInformationParser: _router.routeInformationParser,
    routerDelegate: _router.routerDelegate,
    title: title,
  );

  final _router = router;
}

