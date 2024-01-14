import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());
}

// Loading, loaded, error state
// Load user details

class LoadingUserDetails extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {}

class ErrorLoadingUserDetails extends UserDetailsState {}
