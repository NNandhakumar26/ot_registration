import 'package:flutter/material.dart';

enum ToastType { warning, error, info }

showToast(context, {required String message, bool? success}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    ),
  );
}

showToastTop(context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 160,
        right: 12,
        left: 12,
      ),
      content: Text(message),
    ),
  );
}
