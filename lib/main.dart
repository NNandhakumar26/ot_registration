import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ot_registration/app/app.dart';
import 'package:ot_registration/app/config/dependencies.dart';
import 'package:ot_registration/firebase_options.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('KMC');
  await intializeSingletons();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    RestartWidget(
      child: App(),
    ),
  );
}
