import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ot_registration/app/constants/gaps.dart';
import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/app/helper/services/navigator.dart';
import 'package:ot_registration/app/helper/widgets/empty_item.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/helper/utils/constants.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/modules/profile_settings/settings.dart';
import 'package:ot_registration/presentation/app_user/modules/user_preview/user_preview.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';
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

  final userRepo = getIt.get<UserRepo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        leadingWidth: 0,
        title: Text(
          Constants.appName,
        ),
        actions: [
          if (userRepo.isTherapist && userRepo.user.therapistAccess != null)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: AccessIndicator(
                access: userRepo.user.therapistAccess!,
                isTherapist: true,
                isMini: true,
              ),
            ),
          if (userRepo.isOrganization &&
              userRepo.user.organizationAccess != null)
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: AccessIndicator(
                access: userRepo.user.organizationAccess!,
                isTherapist: false,
                isMini: true,
              ),
            ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.chat);
              },
              icon: Icon(Icons.chat_outlined)),
          SizedBox(
            width: 8,
          ),
          Visibility(
            visible: !userRepo.isGuestAccount,
            replacement: IconButton(
              onPressed: () async {
                await userRepo.signOut(context);
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
            child: IconButton(
              onPressed: () async => await CustomNav.navigateBackWidget(
                context,
                SettingsPage(),
              ),
              icon: Icon(
                Icons.settings_outlined,
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: userRepo.isAdmin,
        child: FloatingActionButton.extended(
          onPressed: () {
            CustomNav.navigateBack(context, Routes.createBlog);
          },
          label: Row(
            children: [
              const Icon(
                FontAwesomeIcons.blogger,
                size: 14,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Add Blog',
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
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black45,
                    ),
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

                return _viewModel.bannerImages.isNotEmpty
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
              child: Column(
                children: [
                  Visibility(
                    visible: userRepo.isAdmin,
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => CustomNav.navigateBackWidget(
                              context,
                              UserListView(access: Access.denied),
                            ),
                            child: Text('Rejected Requests'),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                            ),
                            onPressed: () {
                              CustomNav.navigateBackWidget(
                                context,
                                UserListView(access: Access.pending),
                              );
                            },
                            child: const Text('Pending Requests'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => CustomNav.navigateBackWidget(
                            context,
                            UserListView(
                              access: Access.approved,
                              viewTherapistPage: true,
                            ),
                          ),
                          child: const Text('View Therapists'),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => CustomNav.navigateBackWidget(
                            context,
                            UserListView(
                              access: Access.approved,
                              viewTherapistPage: false,
                            ),
                          ),
                          child: const Text('View Clinics'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Blogs',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.blogsList),
                    child: const Text('View More'),
                  )
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

                return _viewModel.blogs.isNotEmpty
                    ? RecentBlogBuilder(
                        blogs: _viewModel.blogs,
                        isLoading: state is RecentBlogsLoading,
                      )
                    : Column(
                        children: [
                          gapH24,
                          Icon(
                            FontAwesomeIcons.blogger,
                            size: 100,
                            color: Colors.black12,
                          ),
                          gapH16,
                          Text(
                            'No Blogs found',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black38,
                                ),
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AccessIndicator extends StatelessWidget {
  final Access access;
  final bool isTherapist;
  final bool isMini;

  const AccessIndicator({
    required this.access,
    required this.isTherapist,
    required this.isMini,
    super.key,
  });

  MaterialColor get color {
    switch (access) {
      case Access.approved:
        return Colors.green;
      case Access.denied:
        return Colors.red;
      case Access.pending:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String get category => isTherapist ? 'a Therapist' : 'an Organization';

  String get displayText {
    switch (access) {
      case Access.approved:
        return 'You are approved as $category';
      case Access.denied:
        return 'You are denied as $category';
      case Access.pending:
        return 'Request Pending as $category';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      message: displayText,
      textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: color.shade800,
          ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
