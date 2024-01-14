// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/data/model/basic_info.dart';
import 'package:ot_registration/data/model/therapist.dart';
import 'package:ot_registration/data/model/therapy_center.dart';

class AppUser {
  String? fcmToken;
  BasicInfo? therapistInfo;
  BasicInfo? organizationInfo;
  Access? therapistAccess;
  Access? organizationAccess;
  String? registeredEmailAddress;
  String? userId;
  Therapist? therapist;
  Organization? organization;
  AppUser({
    this.fcmToken,
    this.therapistInfo,
    this.organizationInfo,
    this.therapistAccess,
    this.organizationAccess,
    this.registeredEmailAddress,
    this.userId,
    this.therapist,
    this.organization,
  });
  String get displayName =>
      therapistInfo?.name ?? organizationInfo?.name ?? 'Admin User';
  bool get isTherapist => therapistInfo != null;
  bool get isOrganization => organizationInfo != null;

  bool get isRegistrationPending {
    if (therapistInfo == null && organizationInfo == null)
      return true;
    // if (therapistInfo != null && therapist!.isRegistrationPending)
    // return true;
    // if (isTherapist ) {
    //   return therapistAccess == Access.PENDING;
    // } else if (isOrganization) {
    //   return organizationAccess == Access.PENDING;
    // } else {
    //   return false;
    // }
    else
      return false;
  }

  AppUser copyWith({
    String? fcmToken,
    BasicInfo? therapistInfo,
    BasicInfo? organizationInfo,
    Access? therapistAccess,
    Access? organizationAccess,
    String? registeredEmailAddress,
    String? userId,
    Therapist? therapist,
    Organization? organization,
  }) {
    return AppUser(
      fcmToken: fcmToken ?? this.fcmToken,
      therapistInfo: therapistInfo ?? this.therapistInfo,
      organizationInfo: organizationInfo ?? this.organizationInfo,
      therapistAccess: therapistAccess ?? this.therapistAccess,
      organizationAccess: organizationAccess ?? this.organizationAccess,
      registeredEmailAddress:
          registeredEmailAddress ?? this.registeredEmailAddress,
      userId: userId ?? this.userId,
      therapist: therapist ?? this.therapist,
      organization: organization ?? this.organization,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fcmToken': fcmToken,
      'therapistInfo': therapistInfo?.toMap(),
      'organizationInfo': organizationInfo?.toMap(),
      'therapistAccess': therapistAccess?.name,
      'organizationAccess': organizationAccess?.name,
      'registeredEmailAddress': registeredEmailAddress,
      'userId': userId,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      therapistInfo: map['therapistInfo'] != null
          ? BasicInfo.fromMap(map['therapistInfo'] as Map<String, dynamic>)
          : null,
      organizationInfo: map['organizationInfo'] != null
          ? BasicInfo.fromMap(map['organizationInfo'] as Map<String, dynamic>)
          : null,
      therapistAccess: map['therapistAccess'] != null
          ? Access.values
              .firstWhere((element) => element.name == map['therapistAccess'])
          : null,
      organizationAccess: map['organizationAccess'] != null
          ? Access.values.firstWhere(
              (element) => element.name == map['organizationAccess'])
          : null,
      registeredEmailAddress: map['registeredEmailAddress'] != null
          ? map['registeredEmailAddress'] as String
          : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(fcmToken: $fcmToken, therapistInfo: $therapistInfo, organizationInfo: $organizationInfo, therapistAccess: $therapistAccess, organizationAccess: $organizationAccess, registeredEmailAddress: $registeredEmailAddress, userId: $userId, therapist: $therapist, organization: $organization)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.fcmToken == fcmToken &&
        other.therapistInfo == therapistInfo &&
        other.organizationInfo == organizationInfo &&
        other.therapistAccess == therapistAccess &&
        other.organizationAccess == organizationAccess &&
        other.registeredEmailAddress == registeredEmailAddress &&
        other.userId == userId &&
        other.therapist == therapist &&
        other.organization == organization;
  }

  @override
  int get hashCode {
    return fcmToken.hashCode ^
        therapistInfo.hashCode ^
        organizationInfo.hashCode ^
        therapistAccess.hashCode ^
        organizationAccess.hashCode ^
        registeredEmailAddress.hashCode ^
        userId.hashCode ^
        therapist.hashCode ^
        organization.hashCode;
  }
}
