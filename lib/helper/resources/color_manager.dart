import 'dart:math';

import 'package:flutter/material.dart';

class AppColor {
  static const textColor = Color(0xFF353535);
  static const textColorDark = Color(0xFF212121);
  static const textColorLight = Color(0xFFA6A6A6);
  static Color primary = const Color(0xFF0052CC);
  static Color primary2 = const Color(0xFF2684FF);
  static Color darkGrey = const Color(0xFF434343);
  static Color grey = const Color(0xFF8F9BB3);
  static Color midGrey = const Color(0xFFAFACC5);
  static Color lightGrey = const Color(0xFFF6F6F5);
  static Color borderGrey = const Color(0xFFF4F4F4);
  static Color primaryOpacity70 = const Color(0xB3735BF2);
  static Color gold = const Color(0xFFFF8C00);
  static Color transparent = Colors.transparent;
  // static Color scaffoldBackground = const Color(0xffF6F7FA);
  static Color scaffoldBackgroundLight =
      const Color.fromARGB(255, 246, 247, 250);
  static Color scaffoldBackgroundDark =
      const Color.fromARGB(255, 242, 243, 255);

  static Color primaryLight = const Color.fromARGB(255, 168, 198, 215);
  static Color primaryChatLight = const Color(0xffE1F4FC); //B1E4F8
  static Color primaryChatLight2 = const Color(0xffB1E4F8);
  static Color darkPrimary = const Color(0xFF0052CC);
  static Color darkPrimary2 = const Color(0xFF1D1CE5);
  static Color error = const Color(0xFFFF0000);
  static Color grey1 = const Color(0xFF707070);
  static Color grey2 = const Color(0xFF797979);
  static Color white = const Color(0xFFFFFFFF);
  static Color black2 = const Color(0xFF202020);
  static Color black = const Color(0xFF000000);
  static Color success = const Color(0xFF006400);

  static Color gRed = const Color(0xFFDB4437);
  static Color fBlue = const Color(0xFF3b5998);
  static Color iPurple = const Color(0xFF962fbf);

  static MaterialColor getSwatch({required Color color}) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}
