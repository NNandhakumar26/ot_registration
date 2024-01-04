import 'package:flutter/material.dart';

class CustomNav {
  static Future<dynamic> navigate(
      BuildContext context, String routeName) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (Route<dynamic> route) => false,
    );
  }
}
