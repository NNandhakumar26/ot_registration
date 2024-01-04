import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/helper/resources/date_manager.dart';
import 'package:ot_registration/helper/utils/toast.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';
import 'package:ot_registration/presentation/blog/pages/blogDetails/blog_viewmodel.dart';

import 'package:like_button/like_button.dart';

import 'package:ot_registration/helper/resources/color_manager.dart';
import '../../widgets/report_sheet.dart';

class BlogView extends StatefulWidget {
  final Blog blog;
  const BlogView({super.key, required this.blog});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  late BlogViewModel _viewModel;

  @override
  void initState() {
    _viewModel = BlogViewModel();
    context.read<BlogsBloc>().add(GetBlogDetail(blog: widget.blog));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _viewModel.scaffoldState,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'Report') {
                _viewModel.scaffoldState.currentState!.showBottomSheet((_) {
                  return ReportSheet(
                    onReported: (val) {
                      context.read<BlogsBloc>().add(
                          ReportBlog(blogId: widget.blog.id!, reason: val));
                      showToast(context,
                          message: 'Blog reported successfully!');
                    },
                  );
                },
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8));
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Report'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<BlogsBloc, BlogsState>(
          builder: (_, state) {
            if (state is BlogDetailFetched) {
              _viewModel.blog = state.blog;
              _viewModel.isLikedByMe = state.isLikedByMe;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.blog.image != null)
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.blog.image!))),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<BlogsBloc, BlogsState>(builder: (_, state) {
                        if (state is BlogsLoading) {
                          return SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          );
                        } else if (state is BlogDetailFetched) {
                          return LikeButton(
                            size: 40,
                            circleColor: const CircleColor(
                                start: Color(0xff00ddff),
                                end: Color(0xff0099cc)),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: AppColor.darkPrimary,
                              dotSecondaryColor: AppColor.primary,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                Icons.favorite,
                                color: isLiked ? AppColor.gRed : AppColor.grey,
                                size: 24,
                              );
                            },
                            onTap: (isSelected) async {
                              context.read<BlogsBloc>().add(LikeBlog(
                                  blogId: _viewModel.blog!.id!,
                                  likes: !isSelected
                                      ? _viewModel.blog!.likes + 1
                                      : _viewModel.blog!.likes - 1,
                                  isLiked: !isSelected));
                              return !isSelected;
                            },
                            isLiked: _viewModel.isLikedByMe,
                            likeCount: _viewModel.blog!.likes,
                            countBuilder:
                                (int? count, bool isLiked, String text) {
                              var color =
                                  isLiked ? AppColor.textColor : Colors.grey;
                              return Text(
                                text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: color,
                                    ),
                              );
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),

                      TextButton(
                          onPressed: () async {
                            FirebaseDynamicLinks dynamicLinks =
                                FirebaseDynamicLinks.instance;

                            final DynamicLinkParameters parameters =
                                DynamicLinkParameters(
                              uriPrefix: 'https://inzeph.page.link/blogs',
                              longDynamicLink: Uri.parse(
                                'https://inzeph.page.link/blogs?id=${widget.blog.id}',
                              ),
                              link: Uri.parse(
                                  'https://inzeph.page.link/blogs?id=${widget.blog.id}'),
                              androidParameters: const AndroidParameters(
                                packageName: 'com.inzeph.kmc',
                                minimumVersion: 0,
                              ),
                            );

                            var url = await dynamicLinks.buildLink(parameters);

                            // Share.share(url.toString(),
                            //     subject:
                            //         'Hi, ${widget.blog.createdBy} shared this blog from KMC');
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.64),
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Share')
                            ],
                          ))

                      // IconButton(
                      //     onPressed: () async {

                      //     },
                      //     icon: Icon(
                      //       FontAwesomeIcons.share,
                      //       color: AppColor.grey,
                      //       size: 30,
                      //     ))
                    ],
                  ),
                ),
                if (widget.blog.title != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      widget.blog.title!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black87,
                            fontSize: 24,
                          ),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Posted By ${widget.blog.createdBy} @ ${getDateTimeMin(widget.blog.createdAt)}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Colors.black38,
                        ),
                  ),
                ),
                if (widget.blog.content != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    child: Text(
                      widget.blog.content!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 15,
                            // color: AppColor.textColor.withOpacity(0.87),
                            fontWeight: FontWeight.w400,
                            // letterSpacing: 0.4,
                            // wordSpacing: 0.6,
                          ),
                      // textAlign: TextAlign.justify,
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
