import 'package:flutter/material.dart';
import 'package:ot_registration/helper/utils/global.dart';
import 'package:ot_registration/presentation/user/pages/userfeed/userfeed_viewmodel.dart';
import 'package:ot_registration/helper/widgets/empty_item.dart';
import 'package:ot_registration/helper/widgets/shimmer_card.dart';
import 'package:ot_registration/helper/widgets/user_card.dart';
import 'package:ot_registration/helper/widgets/user_details.dart';

class UserList extends StatelessWidget {
  final List<dynamic>? users;
  final bool action;
  final bool isLoading;
  const UserList(
      {super.key,
      required this.users,
      this.action = false,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: isLoading
          ? 2
          : users!.isEmpty
              ? 1
              : users!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      itemBuilder: (_, index) {
        return isLoading
            ? const ShimmerCard()
            : users!.isEmpty
                ? EmptyItem(message: UserFeedViewModel().getMessage(action))
                : UserCard(
                    user: users![index],
                    onClick: Global.isAdmin || users![index].type == 'Clinic'
                        ? () => showBottomSheet(
                            context: context,
                            builder: (_) {
                              return SingleChildScrollView(
                                  child: UserDetails(
                                action: action,
                                user: users![index],
                                buildContext: context,
                              ));
                            })
                        : null,
                  );
      },
    );
  }
}
