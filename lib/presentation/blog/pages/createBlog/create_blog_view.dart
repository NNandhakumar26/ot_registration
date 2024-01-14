import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';
import 'package:ot_registration/presentation/blog/pages/createBlog/create_blog_viewmodel.dart';
import 'package:ot_registration/presentation/chat/blocs/image_bloc/image_bloc.dart';
import 'package:ot_registration/app/resources/color_manager.dart';

class CreateBlogView extends StatefulWidget {
  final Blog? blog;
  const CreateBlogView({super.key, this.blog});

  @override
  State<CreateBlogView> createState() => _CreateBlogViewState();
}

class _CreateBlogViewState extends State<CreateBlogView> {
  late CreateBlogViewModel _viewModel;
  bool hideTempImage = false;

  @override
  void initState() {
    _viewModel = CreateBlogViewModel()..start();
    if (widget.blog != null) {
      _viewModel.updateContent(widget.blog!);
    }
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
            },
          );
        } else if (state is BlogCreated) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(Routes.home);
        } else if (state is ErrorCreatingBlog) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.blog != null ? 'Edit Blog' : 'Create Blog',
          ),
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: _viewModel.canSubmit,
          builder: (context, canSubmit, child) {
            return FloatingActionButton(
              disabledElevation: 0,
              backgroundColor: canSubmit ? null : Colors.grey.shade300,
              onPressed: canSubmit
                  ? () => (widget.blog != null)
                      ? _viewModel.updateBlog(context)
                      : _viewModel.createBlog(context)
                  : null,
              child: Icon(
                Icons.publish,
              ),
            );
          },
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Title',
                  hintText: 'Title',
                ),
                controller: _viewModel.titleController,
                onChanged: (_) => _viewModel.updateIsSubmit(),
              ),
              const SizedBox(
                height: 24,
              ),
              if (widget.blog != null && widget.blog!.image != null)
                Visibility(
                  visible: widget.blog != null && !hideTempImage,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              _viewModel.imageToBeRemoved = widget.blog!.image;
                              hideTempImage = true;
                              setState(() {});

                              // context.read<ImageBloc>().add(CancelImageEvent());
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                      Image.network(
                        widget.blog!.image!,
                      ),
                    ],
                  ),
                ),
              BlocBuilder<ImageBloc, ImageState>(
                builder: (_, state) {
                  if (state is ImageFetched) {
                    if (widget.blog != null) {
                      _viewModel.imageToBeRemoved = widget.blog!.image;
                    }
                    _viewModel.image = state.image.path;
                  } else if (state is CancelImageEvent) {
                    _viewModel.image = null;
                  }

                  return Visibility(
                    visible:
                        state is ImageFetched || widget.blog?.image != null,
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
                        },
                      ),
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
                                    icon: const Icon(Icons.close),
                                  )
                                ],
                              ),
                              Image.file(
                                state.image,
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                  );
                },
              ),
              const SizedBox(
                height: 24,
              ),
              // Text(
              //   'Content',
              //   style: Theme.of(context)
              //       .textTheme
              //       .titleMedium!
              //       .copyWith(color: AppColor.textColor),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              TextFormField(
                // maxLength: 250,
                maxLines: 10,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Describe your post here',
                  labelText: 'Content',
                  fillColor: Colors.white,
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
