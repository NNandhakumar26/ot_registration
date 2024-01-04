import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';
import 'package:ot_registration/presentation/blog/pages/createBlog/create_blog_viewmodel.dart';

import 'package:ot_registration/presentation/chat/blocs/image_bloc/image_bloc.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';

class CreateBlogView extends StatefulWidget {
  const CreateBlogView({super.key});

  @override
  State<CreateBlogView> createState() => _CreateBlogViewState();
}

class _CreateBlogViewState extends State<CreateBlogView> {
  late CreateBlogViewModel _viewModel;

  @override
  void initState() {
    _viewModel = CreateBlogViewModel()..start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogsBloc, BlogsState>(
      listener: (_, state) {
        if (state is BlogsLoading) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        } else if (state is BlogCreated) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(Routes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackgroundLight,
        floatingActionButton: ValueListenableBuilder(
            valueListenable: _viewModel.canSubmit,
            builder: (context, value, child) {
              return Visibility(
                visible: value,
                child: FloatingActionButton(
                  onPressed: () => _viewModel.createBlog(context),
                  child: Icon(
                    Icons.publish,
                  ),

                  //      Row(
                  //   children: [
                  //     const Icon(
                  //       Icons.publish,
                  //       size: 14,
                  //     ),
                  //     // SizedBox(
                  //     //   width: 8,
                  //     // ),
                  //     // Text(
                  //     //   'Publish',
                  //     //   style: Theme.of(context).textTheme.labelLarge,
                  //     // ),
                  //   ],
                  // ),
                ),
              );
            }),
        appBar: AppBar(
          backgroundColor: AppColor.white,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.all(6),
          //     child: OutlinedButton.icon(
          //       style: OutlinedButton.styleFrom(
          //           backgroundColor: AppColor.scaffoldBackgroundLight,
          //           shape: StadiumBorder(),
          //           side: BorderSide(
          //             color: Colors.black12,
          //           )),
          //       onPressed: () {
          //         _viewModel.createBlog(context);
          //       },
          //       icon: Icon(
          //         Icons.send,
          //         size: 14,
          //       ),
          //       label: Text(
          //         'Publish',
          //       ),
          //     ),
          //   ),
          //   SizedBox(
          //     width: 12,
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColor.textColor),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                ),
                controller: _viewModel.titleController,
                onChanged: (_) => _viewModel.updateIsSubmit(),
              ),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<ImageBloc, ImageState>(builder: (_, state) {
                if (state is ImageFetched) {
                  _viewModel.image = state.image.path;
                } else {
                  _viewModel.image = null;
                }

                return Visibility(
                    visible: state is ImageFetched,
                    replacement: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColor.scaffoldBackgroundDark,
                            shape: StadiumBorder(),
                            side: BorderSide(
                              color: Colors.black12,
                            ),
                          ),
                          icon: Icon(
                            Icons.add_a_photo_rounded,
                            size: 14,
                          ),
                          label: Text(
                            'Attach Image File',
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.4,
                            ),
                          ),
                          onPressed: () {
                            context.read<ImageBloc>().add(GetImageEvent());
                          }),
                    ),
                    child: state is ImageFetched
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      splashRadius: 20,
                                      onPressed: () {
                                        context
                                            .read<ImageBloc>()
                                            .add(CancelImageEvent());
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              Image.file(state.image)
                            ],
                          )
                        : const SizedBox.shrink());
              }),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Content',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColor.textColor),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                maxLength: 250,
                maxLines: 10,
                decoration: InputDecoration(
                  counterText: '',

                  // border: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //     width: 0.04,
                  //   ),
                  // ),
                  fillColor: Colors.white,
                  // fillColor: AppColor.scaffoldBackgroundDark,
                ),
                onChanged: (_) => _viewModel.updateIsSubmit(),
                controller: _viewModel.contentController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
