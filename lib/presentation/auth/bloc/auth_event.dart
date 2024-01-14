part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// initializeBuildContext
class InitializeContext extends AuthEvent {
  final BuildContext context;

  InitializeContext(this.context);
}

class GoogleLogin extends AuthEvent {}

class GuestSignIn extends AuthEvent {}
