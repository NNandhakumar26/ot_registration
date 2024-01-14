import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:ot_registration/app/config/dependencies.dart';
import 'package:ot_registration/data/model/app_user.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/data/network/utils/references.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

part 'blogs_event.dart';
part 'blogs_state.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsBloc() : super(BlogsInitial()) {
    on<GetBlogs>(_onGetBlogs);
    on<GetBlogDetail>(_onGetBlogDetail);
    on<LikeBlog>(_onLikeBlog);
    on<ReportBlog>(_onReportBlog);
    on<CreateBlog>(_onCreateBlog);
    on<UpdateBlog>(_onUpdateBlog);
    on<DeleteBlog>(_onDeleteBlog);
  }

  var repo = FirebaseReferences();
  final userRepo = getIt.get<UserRepo>();
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
        return Blog.fromMap(data, blogId: e.id);
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
      // var isLiked = (await repo.likedDB.doc(event.blog.id).get()).exists;
      var isLikedByMe =
          (await repo.likedDB(event.blog.id!).doc(userRepo.uid).get()).exists;

      var createdBy = await repo.userDB.doc(event.blog.createdBy).get();
      var blogDoc = await repo.blogDB.doc(event.blog.id).get();

      Blog blog = Blog.fromMap(blogDoc.data(), blogId: blogDoc.id);

      if (createdBy.exists) {
        var user = AppUser.fromMap(createdBy.data() as Map<String, dynamic>);
        blog = blog.copyWith(
          id: event.blog.id,
          createdBy: user.displayName,
        );
      }

      emit(
        BlogDetailFetched(
          blog: blog,
          isLikedByMe: isLikedByMe,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onLikeBlog(LikeBlog event, Emitter emit) async {
    try {
      await repo.blogDB.doc(event.blogId).update(
        {
          'likes': FieldValue.increment(event.isLiked ? 1 : -1),
        },
      );
      if (event.isLiked) {
        await repo.likedDB(event.blogId).doc(userRepo.uid).set(
          {
            'userId': userRepo.uid,
          },
        );
      } else {
        await repo.likedDB(event.blogId).doc(userRepo.uid).delete();
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
      emit(ErrorCreatingBlog(message: e.toString()));
    }
  }

  // function to update blog
  void _onUpdateBlog(UpdateBlog event, Emitter emit) async {
    emit(BlogsLoading());
    try {
      if (event.imagePathToRemove != null) {
        await FirebaseStorage.instance
            .refFromURL(event.imagePathToRemove!)
            .delete();
      }
      Blog blog = event.blog;
      if (blog.image != null && event.imagePathToRemove != null) {
        var downloadUrl = await uploadFile(blog.image!);
        blog = blog.copyWith(image: downloadUrl);
      }

      await repo.blogDB.doc(event.blog.id).set(
            blog.toMap(),
            SetOptions(
              merge: true,
            ),
          );
      emit(BlogCreated());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(ErrorCreatingBlog(message: e.toString()));
    }
  }

  Future<String> uploadFile(String path) async {
    TaskSnapshot task = await FirebaseReferences.blogStorage()
        .child(
          DateTime.now().millisecondsSinceEpoch.toString(),
        )
        .putFile(File(path));
    return await task.ref.getDownloadURL();
  }

  void _onDeleteBlog(DeleteBlog event, Emitter<BlogsState> emit) async {
    emit(BlogsLoading());
    try {
      await repo.blogDB.doc(event.blogId).delete();
      emit(BlogCreated());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(ErrorCreatingBlog(message: e.toString()));
    }
  }
}
