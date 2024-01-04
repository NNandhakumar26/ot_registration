// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/helper/utils/global.dart';
import 'package:ot_registration/data/model/user.dart';
import 'package:ot_registration/presentation/user/pages/userfeed/userfeed_viewmodel.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';

import '../../../../helper/widgets/user_list.dart';
import '../../bloc/user_bloc.dart';

class UserFeedView extends StatefulWidget {
  const UserFeedView({
    super.key,
  });

  @override
  State<UserFeedView> createState() => _UserFeedViewState();
}

class _UserFeedViewState extends State<UserFeedView> {
  late UserFeedViewModel _viewModel;

  @override
  void initState() {
    _viewModel = UserFeedViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (_, state) {
        if (state is StatusChanged) {
          Navigator.pop(context);
        } else if (state is SignoutSuccess) {
          // Phoenix.rebirth(context);
        } else if (state is Loading) {}
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (_, state) {
          if (state is UsersFetched) {
            _viewModel.users = state.users;
          }
          return Global.isAdmin
              ? AdminView(
                  users: _viewModel.users,
                  isLoading: state is Loading,
                )
              : UserView(
                  users: _viewModel.users,
                  isLoading: state is Loading,
                );
        },
      ),
    );
  }
}

class AdminView extends StatelessWidget {
  final List<User> users;
  final bool isLoading;
  const AdminView({
    super.key,
    required this.users,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    var approved =
        users.where((element) => element.access == 'APPROVED').toList();
    var pending =
        users.where((element) => element.access == 'PENDING').toList();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Admin Approval Panel'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  // margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  // decoration: BoxDecoration(
                  //     color: AppColor.white,
                  //     borderRadius: BorderRadius.circular(8),
                  //     boxShadow: const [
                  //       BoxShadow(
                  //           color: Color(0x1A000000),
                  //           offset: Offset(0, 0),
                  //           blurRadius: 8,
                  //           spreadRadius: 4)
                  //     ]),
                  height: 55,
                  child: const TabBar(tabs: [
                    Tab(
                      text: 'REQUESTS',
                    ),
                    Tab(
                      text: 'APPROVED',
                    ),
                  ]),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      UserList(
                        isLoading: isLoading,
                        action: true,
                        users: pending,
                      ),
                      UserList(
                        users: approved,
                        isLoading: isLoading,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class UserView extends StatelessWidget {
  final List<User> users;
  final bool isLoading;
  const UserView({
    super.key,
    required this.users,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    var approved =
        users.where((element) => element.access == 'APPROVED').toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hi ${Global.name} !',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColor.getSwatch(color: Theme.of(context).primaryColor)
                    .shade900,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
        ),
        actions: [
          if (!Global.isGuest)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: IconButton(
                onPressed: () => UserFeedViewModel().signout(context),
                icon: const Icon(Icons.logout),
              ),
            )
          else
            SizedBox(
              // width: 130,
              height: 40,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade100,
                  ),
                  onPressed: () => context.read<UserBloc>().add(Signout()),
                  child: Row(
                    children: [
                      Icon(
                        Icons.app_registration_outlined,
                        color: Theme.of(context).primaryColor.withOpacity(0.64),
                        size: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Register')
                    ],
                  )),
            )

          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          //   child: FloatingActionButton.extended(
          //       isExtended: true,
          //       icon: const Icon(
          //         Icons.edit,
          //         size: 16,
          //       ),
          //       label: const Text('Register')),
          // )
        ],
      ),
      body: Column(
        children: [
          if (!Global.isGuest && Global.status == 'PENDING')
            InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(Routes.requestStatus),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x1A000000),
                          offset: Offset(0, 0),
                          blurRadius: 8,
                          spreadRadius: 4)
                    ]),
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_clock,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Request Is Pending',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.white.withOpacity(0.97)),
                        ),
                        Text(
                          'Tap to check the approval status',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    )),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          Expanded(child: UserList(isLoading: isLoading, users: approved))
        ],
      ),
    );
  }
}
