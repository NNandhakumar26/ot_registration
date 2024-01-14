import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ot_registration/data/model/custom_user.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  BuildContext? thisContext;
  BuildContext get context => thisContext!;
  AuthBloc() : super(AuthInitial()) {
    on<InitializeContext>(_onInitializeContext);
    on<GoogleLogin>(_onGoogleLogin);
    on<GuestSignIn>(_onGuestSignIn);
  }

  UserRepo repo = getIt.get<UserRepo>();

  FutureOr<void> _onInitializeContext(
      InitializeContext event, Emitter<AuthState> emit) {
    thisContext = event.context;
  }

  void _onGuestSignIn(GuestSignIn event, Emitter emit) async {
    repo.initializeGuestUser();
    await repo.handleUserSignIn(context);
    // emit(GuestUser());
  }

  void _onGoogleLogin(GoogleLogin event, Emitter emit) async {
    emit(Loading());

    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        emit(AuthFailure(message: 'Google sign in failed, Retry!'));
        return;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final userRepo = getIt.get<UserRepo>();

      await userRepo.handleUserSignIn(context);
      emit(Loaded());

      // var email = FirebaseAuth.instance.currentUser!.email;

      // var adminDoc = await repo.adminDB.doc(email).get();

      // if (adminDoc.exists) {
      //   Global.isAdmin = true;
      //   emit(const AuthSuccess());
      //   return;
      // }

      // var doc =
      //     await repo.userDB.doc(FirebaseAuth.instance.currentUser!.uid).get();

      // if (doc.exists) {
      //   var user = CustomUser.fromMap(doc.data());
      //   Global.name = user.name;
      //   Global.status = user.access;
      // }

      // emit(AuthSuccess(isOldUser: doc.exists));
    } on FirebaseAuthException catch (e) {
      String message = getErrorMessage(e.code);
      emit(AuthFailure(message: message));
    } catch (e, s) {
      print('The auth bloc failure is $e with $s');
      emit(AuthFailure(message: e.toString()));
    }
  }
}

String getErrorMessage(String errorCode, {String? param}) {
  switch (errorCode) {
    case "mismatch":
      return "password & confirm password does not match";
    case "unknown":
      return "$param is empty!";
    case "user-not-found":
      return "Sorry buddy, The email address not found";
    case "invalid-email":
      return "Please enter the valid email address";
    case "email-already-in-use":
      return "The given email address is already registered.";
    case "wrong-password":
      return "Wrong password";
    case "account-exists-with-different-credential":
      return "Email already associated with another account";
    case "weak-password":
      return "Password is too easy. Password should contain minimum 8 letters";
    case "operation-not-allowed":
    case "user-disabled":
      return "Something went wrong try different email address";
    default:
      return "Sorry buddy, Something went wrong. Try again later!";
  }
}
