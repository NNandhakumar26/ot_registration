import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/constants/arguments.dart';
import 'package:ot_registration/app/helper/bloc/file_picker/picker_bloc.dart';
import 'package:ot_registration/app/helper/widgets/request_status.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/presentation/auth/bloc/auth_bloc.dart';
import 'package:ot_registration/presentation/app_user/modules/registration/register_view.dart';
import 'package:ot_registration/presentation/auth/pages/signin_view.dart';
import 'package:ot_registration/presentation/blog/bloc/blogs_bloc.dart';
import 'package:ot_registration/presentation/blog/pages/blogDetails/blog_view.dart';
import 'package:ot_registration/presentation/blog/pages/blogsList/blogs_list_view.dart';
import 'package:ot_registration/presentation/blog/pages/createBlog/create_blog_view.dart';
import 'package:ot_registration/presentation/chat/blocs/image_bloc/image_bloc.dart';
import 'package:ot_registration/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:ot_registration/presentation/dashboard/pages/landing_view.dart';
import 'package:ot_registration/presentation/app_user/bloc/user_bloc.dart';

import '../presentation/chat/blocs/chat_bloc/chat_bloc.dart';
import '../presentation/chat/pages/chat_view.dart';
import '../presentation/splash/pages/splash_view.dart';

class Routes {
  //welcome
  static const String splash = "/";

  //auth
  static const String signin = "/signin";
  static const String register = "/register";

  //user
  // static const String userFeed = "/user_feed";
  static const String pdfView = "/pdf_view";
  static const String requestStatus = "/request_status";
  static const String profileSettings = '/profile_settings';

  //home
  static const String blogsList = "/blogs_list";
  static const String blogDetail = "/blog_detail";
  static const String createBlog = "/create_blog";

  static const String chat = "/chat";
  static const String home = "/home";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
          settings: settings,
        );
      case Routes.signin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthBloc(),
            child: const SignInView(),
          ),
          settings: settings,
        );
      case Routes.chat:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => ImageBloc(),
                    ),
                    BlocProvider(create: (_) => ChatBloc()
                        // ..add(
                        //   RequestMessageEvent(),
                        // ),
                        )
                  ],
                  child: const ChatView(),
                ),
            settings: settings);
      case Routes.createBlog:
        return MaterialPageRoute(
          builder: (_) {
            var arguments = settings.arguments as Map<String, dynamic>?;
            Blog? blog;
            if (arguments != null)
              blog = arguments[CustomArgument.blog] as Blog?;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => BlogsBloc()),
                BlocProvider(create: (_) => ImageBloc()),
              ],
              child: CreateBlogView(
                blog: blog,
              ),
            );
          },
          settings: settings,
        );
      case Routes.blogsList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => BlogsBloc()..add(GetBlogs()),
            child: const BlogsListView(),
          ),
          settings: settings,
        );
      case Routes.blogDetail:
        var blog = settings.arguments as Blog;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => BlogsBloc()
                  ..add(
                    GetBlogDetail(blog: blog),
                  ),
              ),
              BlocProvider(
                create: (context) => DashboardBloc(),
              ),
            ],
            child: BlogView(
              blog: blog,
            ),
          ),
          settings: settings,
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) {
            var arguments = settings.arguments as Map<String, dynamic>?;
            var isTherapist = false;
            var isOrganization = false;
            var isUpdateProfile = false;
            if (arguments != null) {
              isTherapist = arguments.containsKey(CustomArgument.isTherapist)
                  ? arguments[CustomArgument.isTherapist] as bool
                  : false;
              isOrganization =
                  arguments.containsKey(CustomArgument.isOrganization)
                      ? arguments[CustomArgument.isOrganization] as bool
                      : false;
              isUpdateProfile =
                  arguments.containsKey(CustomArgument.isUpdateProfile)
                      ? arguments[CustomArgument.isUpdateProfile] as bool
                      : false;
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => PickerBloc()),
                BlocProvider(create: (_) => UserBloc())
              ],
              child: RegisterView(
                isTherapist: isTherapist,
                isOrganization: isOrganization,
                isUpdateProfile: isUpdateProfile,
              ),
            );
          },
          settings: settings,
        );
      // case Routes.userFeed:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) => UserBloc()
      //         ..add(
      //           GetUsers(),
      //         ),
      //       child: const UserFeedView(),
      //     ),
      //     settings: settings,
      //   );
      case Routes.requestStatus:
        return MaterialPageRoute(
          builder: (_) => const RequestStatus(),
          settings: settings,
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DashboardBloc()
              ..add(GetBanner())
              ..add(GetRecentBlogs()),
            child: const LandingView(),
          ),
          settings: settings,
        );
      case Routes.pdfView:
        String link = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => Container(),
          // builder: (_) => PDFView(link: link),
          settings: settings,
        );
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route Not Found'),
        ),
      ),
    );
  }
}
