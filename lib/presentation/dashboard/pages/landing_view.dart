import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/utils/constants.dart';
import 'package:ot_registration/helper/utils/global.dart';
import 'package:ot_registration/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:ot_registration/presentation/dashboard/pages/landing_viewmodel.dart';
import 'package:ot_registration/presentation/dashboard/widgets/banner_carousel.dart';
import 'package:ot_registration/presentation/dashboard/widgets/recent_blog_builder.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  late LandingViewModel _viewModel;

  @override
  void initState() {
    _viewModel = LandingViewModel()..start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: Text(
          Constants.appName,
          style: Theme.of(context).textTheme.headlineSmall!,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.chat);
              },
              icon: Icon(Icons.chat_outlined)),
          SizedBox(
            width: 8,
          ),
          IconButton(
            // onPressed: () {},
            onPressed: () async {
              try {
                var box = Hive.box('KMC');
                box.put('Guest', false);
                Global.isGuest = false;
                await FirebaseAuth.instance.signOut();
              } catch (e) {
                print(e);
              }
              // Phoenix.rebirth(context);
            },

            icon: Icon(Icons.info_outline),
          ),
          SizedBox(
            width: 12,
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: Global.isAdmin,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.createBlog);
          },
          label: Row(
            children: [
              const Icon(
                FontAwesomeIcons.podcast,
                size: 14,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Add Post',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                Constants.appDesc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<DashboardBloc, DashboardState>(
              buildWhen: (_, state) =>
                  state is BannerImagesLoading || state is BannerImagesFetched,
              builder: (_, state) {
                if (state is BannerImagesFetched) {
                  _viewModel.bannerImages = state.images;
                }

                return state is BannerImagesLoading
                    ? CircularProgressIndicator()
                    : _viewModel.bannerImages.isNotEmpty
                        ? BannerCarousel(
                            images: _viewModel.bannerImages,
                            isLoading: state is BannerImagesLoading,
                          )
                        : SizedBox(
                            child: Text('No Banner Images found'),
                          );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Global.isAdmin
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: AppColor.getSwatch(
                                    color: Theme.of(context).primaryColor)
                                .shade50,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.userFeed);
                          },
                          child: const Text('View Requests')),
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.userFeed);
                                },
                                child: const Text('View Therapists'))),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.userFeed);
                                },
                                child: const Text('View Clinics'))),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Blogs',
                      style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.blogsList);
                      },
                      child: const Text('View More'))
                ],
              ),
            ),
            BlocBuilder<DashboardBloc, DashboardState>(
                buildWhen: (_, state) =>
                    state is RecentBlogsLoading || state is RecentBlogsFetched,
                builder: (_, state) {
                  if (state is RecentBlogsFetched) {
                    _viewModel.blogs = state.blogs;
                  }

                  return RecentBlogBuilder(
                      blogs: _viewModel.blogs,
                      isLoading: state is RecentBlogsLoading);
                }),
          ],
        ),
      ),
    );
  }
}
