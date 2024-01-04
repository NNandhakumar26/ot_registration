import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';

class BlogsListViewModel extends BaseViewModel {
  final ScrollController feedScrollController = ScrollController();
  late List<Blog> blogs;

  @override
  void start() {
    blogs = [];
  }

  void attachScroll(BuildContext context) {
    feedScrollController.addListener(() {
      if (feedScrollController.offset >=
              feedScrollController.position.maxScrollExtent &&
          !feedScrollController.position.outOfRange) {
        context.read<BlogsBloc>().add(GetBlogs());
      }
    });
  }

  @override
  void dispose() {}
}
