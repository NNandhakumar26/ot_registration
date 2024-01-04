import 'package:equatable/equatable.dart';

class User extends Equatable {
  
  final String id;
  final String fcmt;
  final String type;

  final List<dynamic> services;
  final String? workingHours;
  final String? website;

  final String name;
  final String? organizationName;
  final String? organizationType;
  final String? organizationHead;
  final String? gender;
  final String? age;
  final String? designation;
  final String? botAt;
  final String? certificate;
  final bool? otMasters;
  final String? specialisation;
  final String? other;
  final String? aiota;
  final String access;
  final String address;
  final String email;
  final String phone;
  final int createdAt;
  final int updatedAt;

  const User({
    required this.id,
    required this.fcmt,
    required this.name,
    required this.type,
    required this.services,
    required this.organizationName,
    required this.organizationType,
    required this.organizationHead,
    required this.workingHours,
    required this.website,
    required this.gender,
    required this.age,
    required this.designation,
    required this.botAt,
    required this.certificate,
    required this.otMasters,
    required this.specialisation,
    required this.other,
    required this.aiota,
    required this.access,
    required this.address,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  

  factory User.fromMap(json) {
    return User(
      id: json['id'],
      fcmt: json['fcmt'],
      type: json['type'],
      workingHours: json['workingHours'],
      website: json['website'],
      services: json['services']??[],
      organizationName : json['organizationName'],
      organizationType : json['organizationType'],
      organizationHead : json['organizationHead'],
      name: json['name'],
      gender: json['gender'],
      age: json['age'],
      designation: json['designation'],
      botAt: json['botAt'],
      certificate: json['certificate'],
      otMasters: json['otMasters'],
      specialisation: json['specialisation'],
      other: json['other'],
      aiota: json['aiota'],
      access: json['access'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  User copyWith(json) {
    return User(
      id: json['id'] ?? id,
      fcmt: json['fcmt'] ?? fcmt,
      type: json['type'] ?? type,
      organizationName: json['organizationName'] ?? organizationName,
      organizationType: json['organizationType'] ?? organizationType,
      organizationHead: json['organizationHead'] ?? organizationHead,
      workingHours: json['workingHours'] ?? workingHours,
      website: json['website'] ?? website,
      services: json['services'] ?? services ??[],
      name: json['name'] ?? name,
      gender: json['gender'] ?? gender,
      age: json['age'] ?? age,
      designation: json['designation'] ?? designation,
      botAt: json['botAt'] ?? botAt,
      certificate: json['certificate'] ?? certificate,
      otMasters: json['otMasters'] ?? otMasters,
      specialisation: json['specialisation'] ?? specialisation,
      other: json['other'] ?? other,
      aiota: json['aiota'] ?? aiota,
      access: json['access'] ?? access,
      address: json['address'] ?? address,
      email: json['email'] ?? email,
      phone: json['phone'] ?? phone,
      createdAt: json['createdAt'] ?? createdAt,
      updatedAt: json['updatedAt'] ?? updatedAt,
    );
  }

  @override
  List<Object?> get props => [];
}