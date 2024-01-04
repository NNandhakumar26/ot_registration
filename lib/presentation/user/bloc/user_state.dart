part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class Loading extends UserState {}

class SignoutSuccess extends UserState {}

class StatusChanged extends UserState {
  final String id;

  const StatusChanged({
    required this.id
  });
}

class UserInitial extends UserState {}

class UsersFetched extends UserState {
  final List<User> users;

  const UsersFetched({
    required this.users
  });
}