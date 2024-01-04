import 'package:flutter/material.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';

class BlogViewModel extends BaseViewModel {
  Blog? blog;
  bool isLikedByMe = false;

  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void start() {}

  @override
  void dispose() {}
}
