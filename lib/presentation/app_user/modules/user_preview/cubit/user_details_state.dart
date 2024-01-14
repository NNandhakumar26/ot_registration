part of 'user_details_cubit.dart';

sealed class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object> get props => [];
}

final class UserDetailsInitial extends UserDetailsState {}
