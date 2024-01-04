// // ignore_for_file: prefer_const_constructors, non_constant_identifier_names, file_names

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ot_registration/app/routes.dart';
// import 'package:ot_registration/presentation/dashboard/bloc/dashboard_bloc.dart';
// import 'package:ot_registration/presentation/dashboard/pages/landing_view.dart';
// import 'package:ot_registration/helper/resources/color_manager.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int _CurrIndx = 0;
//   void _indexPage(int index) {
//     if (index == 1) {
//       Navigator.of(context).pushNamed(Routes.chat);
//     } else {
//       setState(() {
//         _CurrIndx = index;
//       });
//     }
//   }

//   final list = [
//     BlocProvider(
//       create: (_) => DashboardBloc()
//         ..add(GetBanner())
//         ..add(GetRecentBlogs()),
//       child: LandingView(),
//     ),
//     // BlocProvider(
//     //   create: (_)=>UserBloc(),
//     //   child: UserFeedView(),
//     // ),
//     Container(),
//     Container()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: list[_CurrIndx],
//       // bottomNavigationBar: BottomNavigationBar(
//       //   showSelectedLabels: false,
//       //   showUnselectedLabels: false,
//       //   onTap: _indexPage,
//       //   currentIndex: _CurrIndx,
//       //   elevation: 0,
//       //   fixedColor: AppColor.primary,
//       //   items: const [
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.home),
//       //       label: "Home",
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.chat_outlined),
//       //       label: "Chat",
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.info_outline),
//       //       label: "Contact US",
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }
