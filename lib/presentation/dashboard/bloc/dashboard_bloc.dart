import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ot_registration/data/model/blog.dart';

import 'package:ot_registration/data/network/config/firebase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<GetBanner>(_onGetBanner);
    on<GetRecentBlogs>(_onGetRecentBlogs);
  }

  FirebaseClient repo = FirebaseClient();

  void _onGetBanner(GetBanner event, Emitter emit) async {
    emit(BannerImagesLoading());
    try {
      var result = await repo.bannerDoc.get();
      var bannerConfig = result.data() as Map;
      var images = bannerConfig['banners'] as List;
      emit(BannerImagesFetched(images: images));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onGetRecentBlogs(GetRecentBlogs event, Emitter emit) async {
    emit(RecentBlogsLoading());
    try {
      var result = await repo.blogDB
          .limit(3)
          .orderBy('createdAt', descending: true)
          .get();

      var blogs = result.docs.map((e) {
        var data = e.data() as Map;
        data['id'] = e.id;
        return Blog.fromMap(data);
      }).toList();
      emit(RecentBlogsFetched(blogs: blogs));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
