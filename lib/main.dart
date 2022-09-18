import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:simple_tools/screens/download_video.dart';
import 'package:simple_tools/screens/main_page.dart';
import 'package:simple_tools/screens/settings.dart';
import 'package:simple_tools/screens/text_tools.dart';

void main() {
  runApp(build());
}

@override
Widget build() {
  return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: lightColorScheme ?? lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme ?? darkColorScheme,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      initialRoute: "/",
      routes: {
        "/": (context) => const MainPage(),
        "/main_page": (context) => const MainPage(),
        "/settings": (context) => const Settings(),
        "/download_video": (context) => const DownloadVideo(),
        "/text_tools": (context) => const TextTools()
      },
      debugShowCheckedModeBanner: false,
    );
  });
}
