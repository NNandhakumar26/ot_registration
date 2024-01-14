// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BasicInfo {
  String name;
  String location;
  String email;
  String phone;
  String? organizationName;
  BasicInfo({
    required this.name,
    required this.location,
    required this.email,
    required this.phone,
    this.organizationName,
  });

  BasicInfo copyWith({
    String? name,
    String? location,
    String? email,
    String? phone,
    String? organizationName,
  }) {
    return BasicInfo(
      name: name ?? this.name,
      location: location ?? this.location,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      organizationName: organizationName ?? this.organizationName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'location': location,
      'email': email,
      'phone': phone,
      if (organizationName != null) 'organizationName': organizationName,
    };
  }

  factory BasicInfo.fromMap(Map<String, dynamic> map) {
    return BasicInfo(
      name: map['name'] as String,
      location: map['location'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      organizationName: map['organizationName'] != null
          ? map['organizationName'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BasicInfo.fromJson(String source) =>
      BasicInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BasicInfo(name: $name, location: $location, email: $email, phone: $phone, organizationName: $organizationName)';
  }

  @override
  bool operator ==(covariant BasicInfo other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.location == location &&
        other.email == email &&
        other.phone == phone &&
        other.organizationName == organizationName;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        location.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        organizationName.hashCode;
  }
}
