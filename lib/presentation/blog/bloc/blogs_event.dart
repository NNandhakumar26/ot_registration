part of 'blogs_bloc.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();

  @override
  List<Object> get props => [];
}


class GetBlogs extends BlogsEvent {}

class LikeBlog extends BlogsEvent {
  final String blogId;
  final int likes;
  final bool isLiked;

  const LikeBlog({
    required this.blogId,
    required this.likes,
    required this.isLiked
  });
}

class ReportBlog extends BlogsEvent {
  final String blogId;
  final String reason;

  const ReportBlog({
    required this.blogId,
    required this.reason
  });
}

class CreateBlog extends BlogsEvent {
  final Blog blog;

  const CreateBlog({
    required this.blog,
  });
}

class GetBlogDetail extends BlogsEvent {
  final Blog blog;
  const GetBlogDetail({
    required this.blog
  });
}