import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/data/model/app_user.dart';
import 'package:ot_registration/data/model/basic_info.dart';
import 'package:ot_registration/data/model/therapist.dart';
import 'package:ot_registration/data/model/therapy_center.dart';
import 'package:ot_registration/data/network/utils/references.dart';

class Network {
  static final ref = FirebaseReferences();

  static Future<AppUser?> getAppUser(String uid) async {
    try {
      return await ref.userDB.doc(uid).get().then((value) {
        if (value.exists) {
          return AppUser.fromMap(value.data()! as Map<String, dynamic>);
        }
        return null;
      });
    } catch (e) {
      throw e;
    }
  }

  // create app user
  static Future<void> createAppUser(String uid, AppUser appUser) async {
    try {
      await ref.userDB.doc(uid).set(appUser.toMap());
    } catch (e) {
      throw e;
    }
  }

  static Future<void> updateAppUser(String uid, AppUser appUser) async {
    try {
      await ref.userDB.doc(uid).update(appUser.toMap());
    } catch (e) {
      throw e;
    }
  }

  static Future<void> updateTherapistBasicInfo(
      String uid, BasicInfo appUser) async {
    try {
      await ref.userDB.doc(uid).update(
        {
          'therapistInfo': appUser.toMap(),
          'therapistAccess': Access.pending.name,
        },
      );
    } catch (e) {
      throw e;
    }
  }

  static Future<void> updateOrganizationBasicInfo(
      String uid, BasicInfo appUser) async {
    try {
      await ref.userDB.doc(uid).update(
        {
          'organizationInfo': appUser.toMap(),
          'organizationAccess': Access.pending.name,
        },
      );
    } catch (e) {
      throw e;
    }
  }

  static Future<Therapist> getTherapist(String uid) async {
    try {
      return await ref.therapistDB(uid).get().then(
            (value) => Therapist.fromMap(
              value.data()! as Map<String, dynamic>,
            ),
          );
    } catch (e) {
      throw e;
    }
  }

// udpate therapist
  static Future<void> updateTherapist(String uid, Therapist therapist) async {
    try {
      await ref.therapistDB(uid).set(
            therapist.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw e;
    }
  }

  // get Organization
  static Future<Organization> getOrganization(String uid) async {
    try {
      return await ref.organizationDB(uid).get().then((value) {
        return Organization.fromMap(value.data()! as Map<String, dynamic>);
      });
    } catch (e) {
      throw e;
    }
  }

  // update organization
  static Future<void> updateOrganization(
      String uid, Organization organization) async {
    try {
      await ref
          .organizationDB(uid)
          .set(organization.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  // check whether the user is admin or not
  static Future<bool> isAdmin(String email) async {
    try {
      var adminDoc = await ref.adminDB.doc(email).get();
      return adminDoc.exists;
    } catch (e) {
      throw e;
    }
  }
}
