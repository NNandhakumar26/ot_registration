import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ot_registration/app/app.dart';
import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/app/helper/services/navigator.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/data/model/app_user.dart';
import 'package:ot_registration/data/model/basic_info.dart';
import 'package:ot_registration/data/model/therapist.dart';
import 'package:ot_registration/data/model/therapy_center.dart';
import 'package:ot_registration/data/network/utils/network.dart';

class UserRepo {
  User? get firebaseUser => FirebaseAuth.instance.currentUser;
  bool get isUserSignedOut => firebaseUser == null;

  late bool? thisAdmin;
  bool get isAdmin => thisAdmin ?? false;
  late AppUser? thisUser;
  AppUser get user => thisUser!;
  bool get userAccessPending {
    if (isTherapist && user.therapistAccess != Access.approved) {
      return true;
    } else if (isOrganization && user.organizationAccess != Access.approved) {
      return true;
    } else if (isGuestAccount) {
      return true;
    } else
      return false;
  }

  String get uid => firebaseUser!.uid;
  bool get isTherapist => thisUser?.isTherapist ?? false;
  bool get isOrganization => thisUser?.isOrganization ?? false;

  // initialize guest user
  Future initializeGuestUser() async {
    var box = Hive.box('KMC');
    box.put('Guest', true);
  }

  // Check whether the user is guest or not
  bool get isGuestAccount {
    try {
      var box = Hive.box('KMC');
      var isGuest = box.get('Guest');
      if (isGuest != null && isGuest) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future initializeCurrentUser() async {
    thisAdmin = await Network.isAdmin(firebaseUser!.email!);
    if (thisAdmin != null && thisAdmin!) {
      thisUser = null;

      return;
    } else {
      thisUser = await Network.getAppUser(firebaseUser!.uid);
      thisAdmin = null;
      return;
    }
  }

  Future<void> signOut(BuildContext context) async {
    if (isGuestAccount) {
      var box = Hive.box('KMC');
      box.put('Guest', false);
    }
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    RestartWidget.restartApp(context);
  }

  Future<dynamic> handleUserSignIn(BuildContext context) async {
    // CustomNav.navigate(context, Routes.register);
    // return;
    if (isGuestAccount) {
      thisAdmin = false;
      thisUser = null;
      CustomNav.navigate(context, Routes.home);
      return;
    } else if (isUserSignedOut) {
      CustomNav.navigate(context, Routes.signin);
      return;
    } else {
      await initializeCurrentUser();
      if (isAdmin) {
        CustomNav.navigate(context, Routes.home);
        return;
      } else {
        if (thisUser == null || thisUser!.isRegistrationPending) {
          if (thisUser == null) {
            var appUser = AppUser(
              userId: firebaseUser!.uid,
              registeredEmailAddress: firebaseUser!.email,
            );
            await Network.createAppUser(firebaseUser!.uid, appUser);
            thisUser = appUser;
          }
          CustomNav.navigate(context, Routes.register);
          return;
        }
        if (user.isTherapist) {
          user.therapist = await Network.getTherapist(uid);
        }
        if (user.isOrganization) {
          user.organization = await Network.getOrganization(uid);
        }
      }
      CustomNav.navigate(context, Routes.home);
      return;
    }
  }

  Future<void> updateBasicInfo(
      String uid, BasicInfo basicInfo, bool isTherapist) async {
    try {
      if (isTherapist) {
        await Network.updateTherapistBasicInfo(
          uid,
          basicInfo,
        );
        user.therapistInfo = basicInfo;
        user.therapistAccess = Access.pending;
      } else {
        await Network.updateOrganizationBasicInfo(
          uid,
          basicInfo,
        );
        user.organizationInfo = basicInfo;
        user.organizationAccess = Access.pending;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateTherapist(String uid, Therapist therapist) async {
    try {
      await Network.updateTherapist(uid, therapist);
      user.therapist = therapist;
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateOrganization(String uid, Organization organization) async {
    try {
      await Network.updateOrganization(uid, organization);
      user.organization = organization;
    } catch (e) {
      throw e;
    }
  }
}
