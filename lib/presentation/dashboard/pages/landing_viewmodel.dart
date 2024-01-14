import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';

class LandingViewModel extends BaseViewModel {
  late List bannerImages;
  late List<Blog> blogs;

  @override
  void start() {
    bannerImages = [];
    blogs = [];
  }

  @override
  void dispose() {}
}
