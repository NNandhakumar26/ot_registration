part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

class InitApp extends SplashEvent {
  final BuildContext context;

  InitApp(this.context);
}
