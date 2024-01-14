// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Organization {
  List<dynamic>? services;
  String? workingHours;
  String? website;
  String? organizationType;
  String? organizationHead;
  Organization({
    this.services,
    this.workingHours,
    this.website,
    this.organizationType,
    this.organizationHead,
  });

  Organization copyWith({
    List<dynamic>? services,
    String? workingHours,
    String? website,
    String? organizationType,
    String? organizationHead,
  }) {
    return Organization(
      services: services ?? this.services,
      workingHours: workingHours ?? this.workingHours,
      website: website ?? this.website,
      organizationType: organizationType ?? this.organizationType,
      organizationHead: organizationHead ?? this.organizationHead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'services': services,
      'workingHours': workingHours,
      'website': website,
      'organizationType': organizationType,
      'organizationHead': organizationHead,
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      // services: map['services'] != null ? List<dynamic>.from((map['services'] as List<dynamic>) : null,
      workingHours:
          map['workingHours'] != null ? map['workingHours'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      organizationType: map['organizationType'] != null
          ? map['organizationType'] as String
          : null,
      organizationHead: map['organizationHead'] != null
          ? map['organizationHead'] as String
          : null,
      services: map['services'] != null
          ? List<dynamic>.from(map['services'] as List<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Organization.fromJson(String source) =>
      Organization.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Organization(services: $services, workingHours: $workingHours, website: $website, organizationType: $organizationType, organizationHead: $organizationHead)';
  }

  @override
  bool operator ==(covariant Organization other) {
    if (identical(this, other)) return true;

    return listEquals(other.services, services) &&
        other.workingHours == workingHours &&
        other.website == website &&
        other.organizationType == organizationType &&
        other.organizationHead == organizationHead;
  }

  @override
  int get hashCode {
    return services.hashCode ^
        workingHours.hashCode ^
        website.hashCode ^
        organizationType.hashCode ^
        organizationHead.hashCode;
  }
}
