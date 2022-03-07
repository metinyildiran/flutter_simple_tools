import 'package:flutter/material.dart';
import 'custom_colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: CustomColors.purple,
        scaffoldBackgroundColor: Colors.grey[900],
        fontFamily: 'SegoeUI-Bold',
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        )
    );
  }
}