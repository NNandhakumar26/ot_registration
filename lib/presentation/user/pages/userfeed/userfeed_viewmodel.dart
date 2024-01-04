import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/utils/global.dart';

import '../../../../data/model/user.dart';
import '../../bloc/user_bloc.dart';

class UserFeedViewModel extends BaseViewModel {
  List<User> users = [];

  String getMessage(bool action) {
    return action
        ? 'No Requests Received Yet'
        : Global.isAdmin
            ? 'No Approved Data Found'
            : 'All users are waiting for admins approval';
  }

  void signout(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                // border: Border(
                //   top: BorderSide(

                //   )
                // ),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 0),
                      blurRadius: 8,
                      spreadRadius: 4)
                ]),
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sign Out',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: AppColor.black2)),
              const SizedBox(
                height: 20,
              ),
              Text('Do you want to signout from application ?',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.read<UserBloc>().add(Signout()),
                      child: const Text('Yes'),
                    ),
                  )
                ],
              )
            ]),
          );
        });
  }

  @override
  void dispose() {}

  @override
  void start() {}
}
