import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/app/helper/services/navigator.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/data/model/basic_info.dart';
import 'package:ot_registration/data/model/custom_user.dart';
import 'package:ot_registration/data/model/therapist.dart';
import 'package:ot_registration/data/model/therapy_center.dart';
import 'package:ot_registration/data/network/utils/references.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';
import 'package:ot_registration/presentation/auth/bloc/auth_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<RegisterTherapist>(_onRegisterUser);
    on<RegisterClinic>(_onRegisterClinic);
    on<GetUsers>(_onGetUsers);
    // on<ChangeStatus>(_onChangeStatus);
  }

  UserRepo repo = getIt.get<UserRepo>();

  void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // void _onChangeStatus(ChangeStatus event, Emitter emit) async {
  //   emit(Loading());
  //   try {
  //     // await repo.userDB.doc(event.id).update({'access': 'APPROVED'});
  //     add(GetUsers());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void _onGetUsers(GetUsers event, Emitter emit) async {
    emit(Loading());

    try {
      // var result = await repo.userDB.get();

      List<CustomUser> users = [];
      // for (var resultMap in result.docs) {
      //   var data = CustomUser.fromMap(resultMap.data());
      //   users.add(data);
      // }

      emit(UsersFetched(users: users));
    } catch (e) {
      print(e);
    }
  }

  void _onRegisterUser(RegisterTherapist event, Emitter emit) async {
    emit(Registering());
    try {
      var time = DateTime.now().millisecondsSinceEpoch;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      bool isCertificateUpdated = event.exisitingCertificate != null &&
          event.exisitingCertificate != event.fileName;
      Therapist therapist = event.therapist.copyWith(
        // certificate: certificateUrl,
        updatedAt: time,
      );

      if (event.exisitingCertificate != null && isCertificateUpdated) {
        try {
          await FirebaseStorage.instance
              .refFromURL(event.exisitingCertificate!)
              .delete();
          var certificateUrl = await _uploadFile(
            event.filePath!,
            event.fileName!,
          );
          therapist = therapist.copyWith(certificate: certificateUrl);
        } catch (e, s) {
          log('$e, $s');
        }
      } else if (event.exisitingCertificate == null) {
        var certificateUrl = await _uploadFile(
          event.filePath!,
          event.fileName!,
        );
        therapist = therapist.copyWith(certificate: certificateUrl);
      }

      await repo.updateTherapist(repo.uid, therapist);
      await repo.updateBasicInfo(repo.uid, event.therapistInfo, true);
      //TODO: update the FCM token too
      // emit(Registered());
      // await Future.delayed(Duration(seconds: 1));
      CustomNav.navigate(event.context, Routes.home);

      // var data = {
      //   'type': 'Therapist',
      //   'id': FirebaseAuth.instance.currentUser!.uid,
      //   'fcmt': fcmToken,
      //   'name': event.name,
      //   'gender': event.gender,
      //   'age': event.age,
      //   'designation': event.designation,
      //   'organizationName': event.organizationName,
      //   'botAt': event.botAt,
      //   'certificate': certificateUrl,
      //   'otMasters': event.isMaster,
      //   'specialisation': event.specialisation,
      //   'other': event.other,
      //   'aiota': event.aiota,
      //   'access': 'PENDING',
      //   'address': event.address,
      //   'email': event.mail,
      //   'phone': event.contactNumber,
      //   'createdAt': time,
      //   'updatedAt': time,
      // };

      // await repo.userDB.doc(FirebaseAuth.instance.currentUser!.uid).set(data);
      // var data;
      // await repo.updateTherapist(repo.uid, event.therapist);
    } on FirebaseAuthException catch (e) {
      String message = getErrorMessage(e.code);
      // showSnackBar(event.context, message, isError: true);
      emit(RegisterFailure(message: message));
    } catch (e) {
      // showSnackBar(event.context, e.toString(), isError: true);
      emit(RegisterFailure(message: e.toString()));
    }
  }

  void _onRegisterClinic(RegisterClinic event, Emitter emit) async {
    emit(Loading());
    try {
      var time = DateTime.now().millisecondsSinceEpoch;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await repo.updateOrganization(repo.uid, event.organization);
      await repo.updateBasicInfo(repo.uid, event.organizationInfo, false);
      CustomNav.navigate(event.context, Routes.home);

      // var data = {
      //   'type': 'Clinic',
      //   'id': FirebaseAuth.instance.currentUser!.uid,
      //   'fcmt': fcmToken,
      //   'name': event.name,
      //   'organizationType': event.type,
      //   'organizationHead': event.head,
      //   'services': event.services,
      //   'workingHours': event.workingHours,
      //   'access': 'PENDING',
      //   'address': event.address,
      //   'email': event.mail,
      //   'phone': event.contactNumber,
      //   'website': event.website,
      //   'createdAt': time,
      //   'updatedAt': time,
      // };

      // await repo.userDB.doc(FirebaseAuth.instance.currentUser!.uid).set(data);

      // emit(RegisterSuccess(user: CustomUser.fromMap(data)));
    } on FirebaseAuthException catch (e) {
      String message = getErrorMessage(e.code);
      emit(RegisterFailure(message: message));
    } catch (e) {
      // showSnackBar(event.context, e.toString(), isError: true);
      emit(RegisterFailure(message: e.toString()));
    }
  }

  Future<String> _uploadFile(String filePath, String fileName) async {
    try {
      TaskSnapshot snapshot =
          await FirebaseReferences.userDocumentStorage(repo.uid)
              .child(fileName)
              .putFile(File(filePath));
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
