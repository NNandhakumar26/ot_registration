part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class BannerImagesFetched extends DashboardState {
  final List images;

  const BannerImagesFetched({
    required this.images
  });
}

class BannerImagesLoading extends DashboardState {}

class RecentBlogsLoading extends DashboardState {}

class RecentBlogsFetched extends DashboardState {
  final List<Blog> blogs;

  const RecentBlogsFetched({
    required this.blogs
  });
}