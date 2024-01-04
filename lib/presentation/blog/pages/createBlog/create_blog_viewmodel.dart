import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/data/network/config/firebase.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';

class CreateBlogViewModel extends BaseViewModel with ChangeNotifier {
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? image;
  ValueNotifier<bool> canSubmit = ValueNotifier(false);

  @override
  void start() {
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  void createBlog(BuildContext context) {
    context.read<BlogsBloc>().add(CreateBlog(
        blog: Blog(
            title: titleController.text,
            content: contentController.text,
            image: image,
            createdBy: FirebaseClient().getUser()!.uid,
            createdAt: DateTime.now())));
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
