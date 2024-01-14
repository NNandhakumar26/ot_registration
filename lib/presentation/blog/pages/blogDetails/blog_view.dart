import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/config/dependencies.dart';
import 'package:ot_registration/app/constants/arguments.dart';
import 'package:ot_registration/app/helper/services/navigator.dart';
import 'package:ot_registration/app/resources/date_manager.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/data/network/utils/references.dart';
import 'package:ot_registration/helper/utils/toast.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';
import 'package:ot_registration/presentation/blog/pages/blogDetails/blog_viewmodel.dart';
import 'package:like_button/like_button.dart';

import 'package:ot_registration/app/resources/color_manager.dart';
import 'package:ot_registration/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:share_plus/share_plus.dart';
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

  final userRepo = getIt.get<UserRepo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _viewModel.scaffoldState,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) async {
              switch (val) {
                case 'Report':
                  _viewModel.scaffoldState.currentState!.showBottomSheet(
                    (_) {
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
                        maxHeight: MediaQuery.of(context).size.height * 0.8),
                  );
                  break;
                case 'Share':
                  await shareBlog();
                  break;
                case 'Edit':
                  CustomNav.navigateBack(
                    context,
                    Routes.createBlog,
                    arguments: {
                      CustomArgument.blog: widget.blog,
                    },
                  );
                  break;
                case 'Delete':
                  showDialog(
                    context: context,
                    builder: (builder) => AlertDialog(
                      title: Text('Delete Blog'),
                      content:
                          Text('Are you sure you want to delete this blog?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseReferences()
                                .blogDB
                                .doc(widget.blog.id)
                                .delete();
                            context.read<DashboardBloc>().add(GetRecentBlogs());
                            context.read<BlogsBloc>().add(GetBlogs());

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                'Report',
                'Share',
                // if (userRepo.isAdmin) 'Edit',
                if (userRepo.isAdmin) 'Delete',
              ].map(
                (String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                },
              ).toList();
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
            Blog blog = _viewModel.blog ?? widget.blog;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (widget.blog.image != null)
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.blog.image ??
                            'https://conversionfanatics.com/wp-content/themes/seolounge/images/no-image/No-Image-Found-400x264.png',
                      ),
                    ),
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Text(
                    'Posted By ${blog.createdBy} @ ${getDateTimeMin(blog.createdAt)}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.black38,
                        ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<BlogsBloc, BlogsState>(
                        builder: (_, state) {
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
                                  color:
                                      isLiked ? AppColor.gRed : AppColor.grey,
                                  size: 24,
                                );
                              },
                              onTap: (isSelected) async {
                                context.read<BlogsBloc>().add(
                                      LikeBlog(
                                        blogId: _viewModel.blog!.id!,
                                        likes: !isSelected
                                            ? _viewModel.blog!.likes + 1
                                            : _viewModel.blog!.likes - 1,
                                        isLiked: !isSelected,
                                      ),
                                    );
                                return !isSelected;
                              },
                              isLiked: _viewModel.isLikedByMe,
                              likeCount: _viewModel.blog!.likes,
                              countBuilder:
                                  (int? count, bool isLiked, String countText) {
                                var color =
                                    isLiked ? AppColor.textColor : Colors.grey;
                                return Text(
                                  countText,
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
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            await shareBlog();
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
                    ],
                  ),
                ),

                if (widget.blog.content != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    child: Text(
                      widget.blog.content!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            // color: AppColor.textColor.withOpacity(0.87),
                            fontWeight: FontWeight.normal,
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

  Future<void> shareBlog() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://inzeph.page.link/blogs',
      longDynamicLink: Uri.parse(
        'https://inzeph.page.link/blogs?id=${widget.blog.id}',
      ),
      link: Uri.parse('https://inzeph.page.link/blogs?id=${widget.blog.id}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.inzeph.kmc',
        minimumVersion: 0,
      ),
    );

    var url = await dynamicLinks.buildLink(parameters);

    Share.share(
      url.toString(),
      subject: 'Hi, ${widget.blog.createdBy} shared this blog from KMC',
    );
  }
}
