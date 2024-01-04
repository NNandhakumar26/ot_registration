part of 'blogs_bloc.dart';

abstract class BlogsState extends Equatable {
  const BlogsState();
  
  @override
  List<Object> get props => [];
}

class BlogsInitial extends BlogsState {}

class BlogsLoading extends BlogsState {}

class BlogCreated extends BlogsState {}

class BlogsFetched extends BlogsState {
  final List<Blog> blogs;

  const BlogsFetched({
    required this.blogs
  });
}

class Paging extends BlogsState {
  final List<Blog> blogs;

  const Paging({
    required this.blogs
  });
}

class BlogDetailFetched extends BlogsState {
  final bool isLikedByMe;
  final Blog blog;

  const BlogDetailFetched({
    required this.blog,
    required this.isLikedByMe
  });
}