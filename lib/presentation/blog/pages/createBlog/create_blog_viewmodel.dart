import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';

class CreateBlogViewModel extends BaseViewModel with ChangeNotifier {
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? image;
  Blog? blog;
  String? imageToBeRemoved;
  ValueNotifier<bool> canSubmit = ValueNotifier(false);

  @override
  void start() {
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  void updateContent(Blog blog) {
    titleController.text = blog.title ?? '';
    contentController.text = blog.content ?? '';
    this.blog = blog;
    image = blog.image;
    imageToBeRemoved = null;
    updateIsSubmit();
  }

  void createBlog(BuildContext context) {
    UserRepo repo = getIt.get<UserRepo>();
    context.read<BlogsBloc>().add(
          CreateBlog(
            blog: Blog(
              title: titleController.text,
              content: contentController.text,
              image: image,
              createdBy: repo.uid,
              createdAt: DateTime.now(),
            ),
          ),
        );
  }

  void updateBlog(BuildContext context) {
    context.read<BlogsBloc>().add(
          UpdateBlog(
            imagePathToRemove: imageToBeRemoved,
            blog: Blog(
              id: blog!.id,
              likes: blog!.likes,
              report: blog!.report,
              share: blog!.share,
              title: titleController.text,
              content: contentController.text,
              image: image,
              createdBy: blog!.createdBy,
              createdAt: DateTime.now(),
            ),
          ),
        );
  }

  void updateIsSubmit() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      if (canSubmit.value) return;
      canSubmit.value = true;
      notifyListeners();
    } else {
      if (!canSubmit.value) return;

      canSubmit.value = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
