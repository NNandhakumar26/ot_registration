import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<InitApp>(_onInitApp);
  }

  void _onInitApp(InitApp event, Emitter emit) async {
    UserRepo userRepo = getIt.get<UserRepo>();
    await userRepo.handleUserSignIn(event.context);
    return;

    // if (fUser != null) {
    //   var email = fUser.email;
    //   var adminDoc = await repo.adminDB.doc(email).get();

    //   if (adminDoc.exists) {
    //     Global.isAdmin = true;
    //     emit(Home());
    //     return;
    //   }
    //   var user = await repo.userDB
    //       .doc(auth.FirebaseAuth.instance.currentUser!.uid)
    //       .get();

    //   if (user.data() != null) {
    //     var userval = CustomUser.fromMap(user.data());
    //     Global.name = userval.name;
    //     Global.status = userval.access;
    //     emit(Home());
    //   } else {
    //     await auth.FirebaseAuth.instance.signOut();
    //     emit(SignIn());
    //   }
    // } else {
    //   var box = Hive.box('KMC');
    //   var isGuest = box.get('Guest');
    //   if (isGuest != null && isGuest) {
    //     Global.isGuest = true;
    //     emit(Home());
    //   } else {
    //     emit(SignIn());
    //   }
    // }
  }
}
