import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/data/model/user.dart';
import 'package:ot_registration/data/network/config/firebase.dart';

part 'blogs_event.dart';
part 'blogs_state.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsBloc() : super(BlogsInitial()) {
    on<GetBlogs>(_onGetBlogs);
    on<GetBlogDetail>(_onGetBlogDetail);
    on<LikeBlog>(_onLikeBlog);
    on<ReportBlog>(_onReportBlog);
    on<CreateBlog>(_onCreateBlog);
  }

  FirebaseClient repo = FirebaseClient();
  List docs = [];
  List<Blog> blogs = [];
  bool isFinished = false;
  bool isWorking = false;

  void _onGetBlogs(GetBlogs event, Emitter emit) async {
    if (isFinished) {
      return;
    }

    if (isWorking) {
      return;
    } else {
      isWorking = true;
    }

    if (docs.isEmpty) {
      emit(BlogsLoading());
    } else {
      emit(Paging(blogs: blogs));
    }

    try {
      var query = repo.blogDB.limit(10).orderBy('createdAt', descending: true);

      if (docs.isNotEmpty) {
        query = query.startAfterDocument(docs[docs.length - 1]);
      }

      var result = await query.get();
      docs = [...docs, ...result.docs];

      if (result.docs.isEmpty) {
        isFinished = true;
      }

      var blogsData = result.docs.map((e) {
        var data = e.data() as Map;
        data['id'] = e.id;
        return Blog.fromMap(data);
      }).toList();
      blogs = [...blogs, ...blogsData];

      isWorking = false;
      emit(BlogsFetched(blogs: blogs));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onGetBlogDetail(GetBlogDetail event, Emitter emit) async {
    emit(BlogsLoading());
    try {
      var isLiked = (await repo.likedDB.doc(event.blog.id).get()).exists;
      var userDoc = await repo.userDB.doc(event.blog.createdBy).get();
      var blogDoc = await repo.blogDB.doc(event.blog.id).get();

      Blog blog = Blog.fromMap(blogDoc.data());

      if (userDoc.exists) {
        var user = User.fromMap(userDoc.data());
        blog = blog.copyWith(id: event.blog.id, createdBy: user.name);
      }

      emit(BlogDetailFetched(blog: blog, isLikedByMe: isLiked));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onLikeBlog(LikeBlog event, Emitter emit) async {
    try {
      await repo.blogDB.doc(event.blogId).update({'likes': event.likes});
      if (event.isLiked) {
        await repo.likedDB.doc(event.blogId).set({'liked': true});
      } else {
        await repo.likedDB.doc(event.blogId).delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onReportBlog(ReportBlog event, Emitter emit) async {
    try {
      await repo.blogDB.doc(event.blogId).update({'report': event.reason});

      await repo.reportDB.doc(event.blogId).set({'reason': event.reason});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onCreateBlog(CreateBlog event, Emitter emit) async {
    emit(BlogsLoading());
    try {
      var blog = event.blog;
      if (blog.image != null) {
        var downloadUrl = await uploadFile(blog.image!);
        blog = blog.copyWith(image: downloadUrl);
      }

      await repo.blogDB.add(blog.toMap());
      emit(BlogCreated());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String> uploadFile(String path) async {
    TaskSnapshot task =
        await repo.storageReference.child('blogs').putFile(File(path));
    return await task.ref.getDownloadURL();
  }
}
