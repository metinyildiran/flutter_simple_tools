import 'package:flutter/material.dart';
import 'package:simple_tools/screens/main_page.dart';
import 'package:simple_tools/screens/settings.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => const MainPage(),
        "/main_page": (context) => const MainPage(),
        "/settings": (context) => const Settings()
      },
      debugShowCheckedModeBanner: false));
}
