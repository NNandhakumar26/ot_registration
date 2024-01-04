part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUsers extends UserEvent {}

class Signout extends UserEvent {}

class RegisterNow extends UserEvent {}

class ChangeStatus extends UserEvent {
  final String id;
  const ChangeStatus({
    required this.id
  });
}