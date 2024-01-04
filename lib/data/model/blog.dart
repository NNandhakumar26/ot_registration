// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Blog extends Equatable {

  final String? id;
  final String? title;
  final String? content;
  final String? image;
  final int likes;
  final int share;
  final String report;

  final String createdBy;
  final DateTime createdAt;

  const Blog({
    this.title,
    this.id = '',
    this.content,
    this.image,
    this.likes = 0,
    this.share = 0,
    this.report = '',
    required this.createdBy,
    required this.createdAt,
  });
  
  @override
  List<Object> get props {
    return [
      title??'',
      content??'',
      image??'',
      likes,
      share,
      report,
      createdBy,
      createdAt,
    ];
  }


  Blog copyWith({
    String? id,
    String? title,
    String? content,
    String? image,
    int? likes,
    int? share,
    String? report,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Blog(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      share: share ?? this.share,
      report: report ?? this.report,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
      'image': image,
      'likes': likes,
      'share': share,
      'report': report,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Blog.fromMap(map) {
    return Blog(
      id: map['id'] != null ? map['id'] as String : "",
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      likes: map['likes']!=null ? map['likes'] as int : 0,
      share: map['share']!=null ? map['share'] as int : 0,
      report: map['report'] ?? '',
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Blog.fromJson(String source) => Blog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
