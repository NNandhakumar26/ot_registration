import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ot_registration/helper/utils/global.dart';
import 'package:ot_registration/data/network/config/firebase.dart';
import 'package:ot_registration/data/model/user.dart' as model;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<GoogleLogin>(_onGoogleLogin);
    on<RegisterUser>(_onRegisterUser);
    on<RegisterClinic>(_onRegisterClinic);
    on<GuestSignIn>(_onGuestSignIn);
  }

  FirebaseClient repo = FirebaseClient();

  void _onGuestSignIn(GuestSignIn event, Emitter emit) async {
    var box = Hive.box('KMC');
    box.put('Guest', true);
    emit(GuestUser());
  }

  void _onRegisterUser(RegisterUser event, Emitter emit) async {
    emit(Loading());
    try {
      var time = DateTime.now().millisecondsSinceEpoch;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      var certificateUrl = await _uploadFile(event.filePath, event.fileName);

      var data = {
        'type': 'Therapist',
        'id': FirebaseAuth.instance.currentUser!.uid,
        'fcmt': fcmToken,
        'name': event.name,
        'gender': event.gender,
        'age': event.age,
        'designation': event.designation,
        'organizationName': event.organizationName,
        'botAt': event.botAt,
        'certificate': certificateUrl,
        'otMasters': event.isMaster,
        'specialisation': event.specialisation,
        'other': event.other,
        'aiota': event.aiota,
        'access': 'PENDING',
        'address': event.address,
        'email': event.mail,
        'phone': event.contactNumber,
        'createdAt': time,
        'updatedAt': time,
      };

      await repo.userDB.doc(FirebaseAuth.instance.currentUser!.uid).set(data);

      emit(RegisterSuccess(user: model.User.fromMap(data)));
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      emit(AuthFailure(message: message));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void _onRegisterClinic(RegisterClinic event, Emitter emit) async {
    emit(Loading());
    try {
      var time = DateTime.now().millisecondsSinceEpoch;
      final fcmToken = await FirebaseMessaging.instance.getToken();

      var data = {
        'type': 'Clinic',
        'id': FirebaseAuth.instance.currentUser!.uid,
        'fcmt': fcmToken,
        'name': event.name,
        'organizationType': event.type,
        'organizationHead': event.head,
        'services': event.services,
        'workingHours': event.workingHours,
        'access': 'PENDING',
        'address': event.address,
        'email': event.mail,
        'phone': event.contactNumber,
        'website': event.website,
        'createdAt': time,
        'updatedAt': time,
      };

      await repo.userDB.doc(FirebaseAuth.instance.currentUser!.uid).set(data);

      emit(RegisterSuccess(user: model.User.fromMap(data)));
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      emit(AuthFailure(message: message));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void _onGoogleLogin(GoogleLogin event, Emitter emit) async {
    emit(Loading());

    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      var email = FirebaseAuth.instance.currentUser!.email;

      var adminDoc = await repo.adminDB.doc(email).get();

      if (adminDoc.exists) {
        Global.isAdmin = true;
        emit(const AuthSuccess());
        return;
      }

      var doc =
          await repo.userDB.doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (doc.exists) {
        var user = model.User.fromMap(doc.data());
        Global.name = user.name;
        Global.status = user.access;
      }

      emit(AuthSuccess(isOldUser: doc.exists));
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      emit(AuthFailure(message: message));
    } catch (e, s) {
      print('The auth bloc failure is $e with $s');
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<String> _uploadFile(String filePath, String fileName) async {
    try {
      TaskSnapshot snapshot = await repo.userDocumentStorage
          .child(fileName)
          .putFile(File(filePath));
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  String _getErrorMessage(String errorCode, {String? param}) {
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
}
