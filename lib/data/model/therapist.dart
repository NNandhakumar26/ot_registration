// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Therapist {
  String? gender;
  String? age;
  String? designation;
  String? botAt;
  String? certificate;
  bool? otMasters;
  String? specialisation;
  String? organizationName;
  String? other;
  String? aiotaMembership;
  int createdAt;
  int updatedAt;
  Therapist({
    this.gender,
    this.age,
    this.designation,
    this.botAt,
    this.certificate,
    this.otMasters,
    this.specialisation,
    this.organizationName,
    this.other,
    this.aiotaMembership,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRegistrationPending =>
      gender == null ||
      age == null ||
      designation == null ||
      botAt == null ||
      certificate == null ||
      otMasters == null ||
      specialisation == null ||
      other == null;

  Therapist copyWith({
    String? gender,
    String? age,
    String? designation,
    String? botAt,
    String? certificate,
    bool? otMasters,
    String? specialisation,
    String? organizationName,
    String? other,
    String? aiotaMembership,
    int? createdAt,
    int? updatedAt,
  }) {
    return Therapist(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      designation: designation ?? this.designation,
      botAt: botAt ?? this.botAt,
      certificate: certificate ?? this.certificate,
      otMasters: otMasters ?? this.otMasters,
      specialisation: specialisation ?? this.specialisation,
      organizationName: organizationName ?? this.organizationName,
      other: other ?? this.other,
      aiotaMembership: aiotaMembership ?? this.aiotaMembership,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gender': gender,
      'age': age,
      'designation': designation,
      'botAt': botAt,
      'certificate': certificate,
      'otMasters': otMasters,
      'specialisation': specialisation,
      'organizationName': organizationName,
      'other': other,
      'aiotaMembership': aiotaMembership,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Therapist.fromMap(Map<String, dynamic> map) {
    return Therapist(
      gender: map['gender'] != null ? map['gender'] as String : null,
      age: map['age'] != null ? map['age'] as String : null,
      designation:
          map['designation'] != null ? map['designation'] as String : null,
      botAt: map['botAt'] != null ? map['botAt'] as String : null,
      certificate:
          map['certificate'] != null ? map['certificate'] as String : null,
      otMasters: map['otMasters'] != null ? map['otMasters'] as bool : null,
      specialisation: map['specialisation'] != null
          ? map['specialisation'] as String
          : null,
      organizationName: map['organizationName'] != null
          ? map['organizationName'] as String
          : null,
      other: map['other'] != null ? map['other'] as String : null,
      aiotaMembership: map['aiotaMembership'] != null
          ? map['aiotaMembership'] as String
          : null,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Therapist.fromJson(String source) =>
      Therapist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Therapist(gender: $gender, age: $age, designation: $designation, botAt: $botAt, certificate: $certificate, otMasters: $otMasters, specialisation: $specialisation, organizationName: $organizationName, other: $other, aiotaMembership: $aiotaMembership, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Therapist other) {
    if (identical(this, other)) return true;

    return other.gender == gender &&
        other.age == age &&
        other.designation == designation &&
        other.botAt == botAt &&
        other.certificate == certificate &&
        other.otMasters == otMasters &&
        other.specialisation == specialisation &&
        other.organizationName == organizationName &&
        other.other == other &&
        other.aiotaMembership == aiotaMembership &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return gender.hashCode ^
        age.hashCode ^
        designation.hashCode ^
        botAt.hashCode ^
        certificate.hashCode ^
        otMasters.hashCode ^
        specialisation.hashCode ^
        organizationName.hashCode ^
        other.hashCode ^
        aiotaMembership.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
