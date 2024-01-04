import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ot_registration/data/network/config/firebase.dart';
import 'package:ot_registration/data/model/user.dart';
import 'package:ot_registration/helper/utils/global.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<InitApp>(_onInitApp);
  }

  FirebaseClient repo = FirebaseClient();

  void _onInitApp(InitApp event, Emitter emit) async {
    auth.User? fUser = auth.FirebaseAuth.instance.currentUser;
    if (fUser != null) {
      var email = fUser.email;
      var adminDoc = await repo.adminDB.doc(email).get();

      if (adminDoc.exists) {
        Global.isAdmin = true;
        emit(Home());
        return;
      }
      var user = await repo.userDB
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (user.data() != null) {
        var userval = User.fromMap(user.data());
        Global.name = userval.name;
        Global.status = userval.access;
        emit(Home());
      } else {
        await auth.FirebaseAuth.instance.signOut();
        emit(SignIn());
      }
    } else {
      var box = Hive.box('KMC');
      var isGuest = box.get('Guest');
      if (isGuest != null && isGuest) {
        Global.isGuest = true;
        emit(Home());
      } else {
        emit(SignIn());
      }
    }
  }
}
