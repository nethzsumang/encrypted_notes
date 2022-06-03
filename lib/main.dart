import 'package:flutter/material.dart';
import 'package:encrypted_notes/app/router/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  static const title = 'Encrypted Notes';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routeInformationParser: _router.routeInformationParser,
    routerDelegate: _router.routerDelegate,
    title: title,
    builder: EasyLoading.init()
  );

  final _router = router;
}

