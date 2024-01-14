import 'package:flutter/material.dart';

class CustomNav {
  static Future<dynamic> navigate(BuildContext context, String routeName,
      {Object? arguments}) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static Future<dynamic> navigateBack(BuildContext context, String routeName,
      {Object? arguments}) async {
    await Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> navigateBackWidget(
      BuildContext context, Widget widget) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }
}
