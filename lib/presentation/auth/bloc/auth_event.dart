part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleLogin extends AuthEvent {}

class GuestSignIn extends AuthEvent {}
class RegisterUser extends AuthEvent {
  final String name;
  final String gender;
  final String age;
  final String designation;
  final String organizationName;
  final String botAt;
  final String filePath;
  final String fileName;
  final bool isMaster;
  final String specialisation;
  final String other;
  final String aiota;
  final String address;
  final String mail;
  final String contactNumber;

  const RegisterUser({
    required this.name,
    required this.gender,
    required this.age,
    required this.designation,
    required this.organizationName,
    required this.botAt,
    required this.filePath,
    required this.fileName,
    required this.isMaster,
    required this.specialisation,
    required this.other,
    required this.aiota,
    required this.address,
    required this.mail,
    required this.contactNumber,
  });
}

class RegisterClinic extends AuthEvent {
  final String name;
  final String type;
  final String head;
  final String workingHours;
  final String address;
  final String mail;
  final String contactNumber;
  final String website;
  final List<Map> services;

  const RegisterClinic({
    required this.address,
    required this.contactNumber,
    required this.type,
    required this.head,
    required this.mail,
    required this.name,
    required this.website,
    required this.workingHours,
    required this.services
  });
}