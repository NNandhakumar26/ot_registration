part of 'blogs_bloc.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();

  @override
  List<Object> get props => [];
}

// TODO: Implement

// class GetRecentBlogs extends BlogsEvent {}

class GetPaginatedBlogs extends BlogsEvent {
  // page number
  final int? currentPageNumber;
  final int itemsPerPage;

  const GetPaginatedBlogs({
    this.currentPageNumber,
    required this.itemsPerPage,
  });
}

class GetBlogs extends BlogsEvent {}

class LikeBlog extends BlogsEvent {
  final String blogId;
  final int likes;
  final bool isLiked;

  const LikeBlog(
      {required this.blogId, required this.likes, required this.isLiked});
}

class ReportBlog extends BlogsEvent {
  final String blogId;
  final String reason;

  const ReportBlog({required this.blogId, required this.reason});
}

class CreateBlog extends BlogsEvent {
  final Blog blog;

  const CreateBlog({
    required this.blog,
  });
}

// update blog
class UpdateBlog extends BlogsEvent {
  final Blog blog;
  final String? imagePathToRemove;

  const UpdateBlog({
    required this.blog,
    this.imagePathToRemove,
  });
}

// Delete blog
class DeleteBlog extends BlogsEvent {
  final String blogId;

  const DeleteBlog({required this.blogId});
}

class GetBlogDetail extends BlogsEvent {
  final Blog blog;
  const GetBlogDetail({required this.blog});
}
