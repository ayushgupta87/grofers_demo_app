import 'package:ayush_gupta/screens/login_screen.dart';
import 'package:ayush_gupta/screens/products_page.dart';
import 'package:ayush_gupta/screens/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff7cdc41),
      ),
      home: LoginPage(),
    );
  }
}
