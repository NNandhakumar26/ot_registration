part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// Register Therapist, Register organization

class RegisterTherapist extends UserEvent {
  // final String name;
  // final String gender;
  // final String age;
  // final String designation;
  // final String organizationName;
  // final String botAt;
  final BuildContext context;
  final String? filePath;
  final String? fileName;
  // final bool isMaster;
  // final String specialisation;
  // final String other;
  // final String aiota;
  // final String address;
  // final String mail;
  // final String contactNumber;
  final Therapist therapist;
  final BasicInfo therapistInfo;
  final String? exisitingCertificate;

  const RegisterTherapist({
    // required this.name,
    // required this.gender,
    // required this.age,
    // required this.designation,
    // required this.organizationName,
    // required this.botAt,    // required this.isMaster,
    // required this.specialisation,
    // required this.other,
    // required this.aiota,
    // required this.address,
    // required this.mail,
    // required this.contactNumber,
    required this.filePath,
    required this.fileName,
    required this.context,
    required this.therapist,
    required this.therapistInfo,
    this.exisitingCertificate = null,
  });
}

class RegisterClinic extends UserEvent {
  // final String name;
  // final String type;
  // final String head;
  // final String workingHours;
  // final String address;
  // final String mail;
  // final String contactNumber;
  // final String website;
  // final List<Map> services;
  final BuildContext context;
  final Organization organization;
  final BasicInfo organizationInfo;

  const RegisterClinic({
    required this.context,
    required this.organization,
    required this.organizationInfo,
    // required this.address,
    // required this.contactNumber,
    // required this.type,
    // required this.head,
    // required this.mail,
    // required this.name,
    // required this.website,
    // required this.workingHours,
    // required this.services,
  });
}

class GetApprovedUsers extends UserEvent {}

class GetPendingUsers extends UserEvent {}

class ApproveUser extends UserEvent {
  final String id;
  const ApproveUser({required this.id});
}

class GetUsers extends UserEvent {
  final Access access;
  final bool userType;

  const GetUsers({
    required this.access,
    required this.userType,
  });
}

class ChangeStatus extends UserEvent {
  final String id;
  const ChangeStatus({required this.id});
}
