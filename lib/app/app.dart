import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/helper/resources/theme_manager.dart';

import '../presentation/splash/bloc/splash_bloc.dart';
import '../presentation/splash/pages/splash_view.dart';

class App extends StatelessWidget {
  const App._internal();
  static const _instance = App._internal();
  factory App() => _instance;

  @override
  Widget build(BuildContext context) {
    return getMaterialApp(
        widget: BlocProvider(
          create: (_) => SplashBloc()..add(InitApp()),
          child: const SplashView(),
        ),
        title: 'EM',
        buildContext: context);
  }

  Widget getMaterialApp(
      {required Widget widget,
      required String title,
      required BuildContext buildContext}) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: widget,
      onGenerateRoute: RouteGenerator.getRoute,
      theme: Themes.buildTheme(Brightness.light),
    );
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }
}
