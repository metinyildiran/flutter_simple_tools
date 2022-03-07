import 'package:flutter/material.dart';
import 'package:simple_tools/screens/download_video.dart';
import 'package:simple_tools/screens/main_page.dart';
import 'package:simple_tools/screens/settings.dart';
import 'package:simple_tools/screens/text_tools.dart';
import 'package:simple_tools/theme/custom_theme.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const MainPage(),
      "/main_page": (context) => const MainPage(),
      "/settings": (context) => const Settings(),
      "/download_video": (context) => const DownloadVideo(),
      "/text_tools": (context) => const TextTools()
    },
    debugShowCheckedModeBanner: false,
  ));
}
