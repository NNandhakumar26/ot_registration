import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ot_registration/data/network/config/firebase.dart';
import 'package:ot_registration/helper/utils/global.dart';
import 'package:ot_registration/data/model/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUsers>(_onGetUsers);
    on<ChangeStatus>(_onChangeStatus);
    on<Signout>(_onSignOut);
  }

  FirebaseClient repo = FirebaseClient();

  void _onSignOut(Signout event, Emitter emit) async {
    try {
      var box = Hive.box('KMC');
      box.put('Guest', false);
      Global.isGuest = false;
      await auth.FirebaseAuth.instance.signOut();
      emit(SignoutSuccess());
    } catch (e) {
      print(e);
    }
  }

  void _onChangeStatus(ChangeStatus event, Emitter emit) async {
    emit(Loading());
    try {
      await repo.userDB.doc(event.id).update({'access': 'APPROVED'});
      add(GetUsers());
    } catch (e) {
      print(e);
    }
  }

  void _onGetUsers(GetUsers event, Emitter emit) async {
    emit(Loading());

    try {
      var result = await repo.userDB.get();

      List<User> users = [];
      for (var resultMap in result.docs) {
        var data = User.fromMap(resultMap.data());
        users.add(data);
      }

      emit(UsersFetched(users: users));
    } catch (e) {
      print(e);
    }
  }
}
