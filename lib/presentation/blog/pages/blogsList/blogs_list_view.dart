import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';
import 'package:ot_registration/presentation/blog/widgets/blogs_builder.dart';

import 'blogs_list_viewmodel.dart';

class BlogsListView extends StatefulWidget {
  const BlogsListView({super.key});

  @override
  State<BlogsListView> createState() => _BlogsListViewState();
}

class _BlogsListViewState extends State<BlogsListView> {
  late BlogsListViewModel _viewModel;

  @override
  void initState() {
    _viewModel = BlogsListViewModel()
      ..start()
      ..attachScroll(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: BlocBuilder<BlogsBloc, BlogsState>(
        builder: (_, state) {
          if (state is BlogsFetched) {
            _viewModel.blogs = state.blogs;
          } else if (state is Paging) {
            _viewModel.blogs = state.blogs;
          }

          return BlogsBuilder(
            controller: _viewModel.feedScrollController,
            blogs: _viewModel.blogs,
            isLoading: state is BlogsLoading,
            isPaging: state is Paging,
          );
        },
      ),
    );
  }
}
