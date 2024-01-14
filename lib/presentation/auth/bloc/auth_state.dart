part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Loading extends AuthState {}

// Loaded
class Loaded extends AuthState {}

class GuestUser extends AuthState {}

class AuthSuccess extends AuthState {
  final bool isOldUser;
  const AuthSuccess({this.isOldUser = true});
}

class RegisterSuccess extends AuthState {
  final CustomUser user;
  const RegisterSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});
}
