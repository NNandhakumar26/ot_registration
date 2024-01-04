import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ot_registration/helper/resources/appconfig.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';

abstract class Themes {
  static const double columnWidth = 360.0;

  static const double navRailWidth = 64.0;

  static bool isColumnModeByWidth(double width) =>
      width > columnWidth * 2 + navRailWidth;

  static bool isColumnMode(BuildContext context) =>
      isColumnModeByWidth(MediaQuery.of(context).size.width);

  static const fallbackTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontFamilyFallback: ['NotoEmoji'],
  );

  static var fallbackTextTheme = const TextTheme(
    bodyLarge: fallbackTextStyle,
    bodyMedium: fallbackTextStyle,
    labelLarge: fallbackTextStyle,
    bodySmall: fallbackTextStyle,
    labelSmall: fallbackTextStyle,
    displayLarge: fallbackTextStyle,
    displayMedium: fallbackTextStyle,
    displaySmall: fallbackTextStyle,
    headlineMedium: fallbackTextStyle,
    headlineSmall: fallbackTextStyle,
    titleLarge: fallbackTextStyle,
    titleMedium: fallbackTextStyle,
    titleSmall: fallbackTextStyle,
  );

  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeInOut;

  static ThemeData buildTheme(Brightness brightness, [Color? seed]) =>
      ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: brightness,
        colorSchemeSeed: seed ?? AppConfig.colorSchemeSeed,
        textTheme: Platform.isWindows || kIsWeb
            ? brightness == Brightness.light
                ? Typography.material2018().black.merge(fallbackTextTheme)
                : Typography.material2018().white.merge(fallbackTextTheme)
            : null,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        dividerColor: brightness == Brightness.light
            ? Colors.blueGrey.shade50
            : Colors.blueGrey.shade900,
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.midGrey,
              // width: 1,
            ),
            // borderRadius: BorderRadius.circular(4),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.textColor.withOpacity(0.08),
              width: 1,
            ),
            // borderRadius: BorderRadius.circular(4),
            // gapPadding: 4.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.primaryLight.withOpacity(0.45),
              width: 0.8,
            ),
            // borderRadius: BorderRadius.circular(AppSize.s4),
            // gapPadding: 4.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.primary,
              width: 1,
            ),
            // borderRadius: BorderRadius.circular(AppSize.s4),
            // gapPadding: 2.0,
          ),
          // border: UnderlineInputBorder(
          //   borderSide: BorderSide.none,
          //   borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //       // color: Colors.greenAccent,
          //       ),
          // ),
          // // border
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //       // color: Colors.red,
          //       ),
          // ),

          filled: true,
          fillColor: Colors.white,

          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontFamilyFallback: ['NotoEmoji'],
            fontSize: 14,
            color: Colors.black26,
          ),
        ),
        scaffoldBackgroundColor: AppColor.scaffoldBackgroundLight,
        appBarTheme: AppBarTheme(
          surfaceTintColor:
              brightness == Brightness.light ? Colors.white : Colors.black,
          shadowColor: Colors.black.withAlpha(64),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: brightness.reversed,
            statusBarBrightness: brightness,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColor.midGrey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
            ),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            ),
          ),
        ),
      );
}

extension on Brightness {
  Brightness get reversed =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
