import 'package:go_router/go_router.dart';
import 'package:encrypted_notes/app/pages/index_page.dart';
import 'package:encrypted_notes/app/pages/counter_page.dart';

var router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const IndexPage(),
    ),
    GoRoute(
      path: '/counter',
      builder: (context, state) =>  const CounterPage(title: 'Flutter Demo Home Page'),
    ),
  ],
);