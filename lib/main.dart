import 'package:flutter/material.dart';

import 'page/homepage.dart';
import 'page/register_page.dart';
import 'page/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}