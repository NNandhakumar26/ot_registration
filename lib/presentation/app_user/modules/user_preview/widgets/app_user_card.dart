import 'package:flutter/material.dart';
import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/app/resources/color_manager.dart';
import 'package:ot_registration/data/model/app_user.dart';
import 'package:ot_registration/data/model/basic_info.dart';
import 'package:ot_registration/presentation/app_user/modules/user_preview/widgets/app_user_details.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUserCard extends StatelessWidget {
  final AppUser user;
  final UserRepo userRepo;
  final bool isTherapist;
  final Function(Access) onAccessChanged;

  AppUserCard({
    super.key,
    required this.user,
    required this.userRepo,
    required this.isTherapist,
    required this.onAccessChanged,
  }) : canShowDetails = !(userRepo.isAdmin ||
            (userRepo.userAccessPending != true) ||
            (userRepo.isGuestAccount != true));

  BasicInfo get basicInfo =>
      isTherapist ? user.therapistInfo! : user.organizationInfo!;
  final bool canShowDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (userRepo.isGuestAccount) {
          showDialog(
            context: context,
            builder: (builder) => AlertDialog(
              title: Text('Guest Account'),
              content: Text('Please login to view details'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'))
              ],
            ),
          );
          return;
        } else {
          showBottomSheet(
            context: context,
            builder: (_) {
              return SingleChildScrollView(
                child: AppUserPage(
                  user: user,
                  repo: userRepo,
                  isTherapist: isTherapist,
                  onAccessChanged: onAccessChanged,
                ),
              );
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: isTherapist
                      ? Colors.cyan.withOpacity(0.1)
                      : Colors.blueAccent.withOpacity(0.1),
                  child: Icon(isTherapist ? Icons.person : Icons.local_hospital,
                      color: isTherapist
                          ? Colors.cyan.withOpacity(0.4)
                          : Colors.blueAccent.withOpacity(0.4)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      basicInfo.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Visibility(
                      visible: canShowDetails,
                      replacement: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message: 'Available only for registered users!',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.lock,
                              color: AppColor.gRed,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Email Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColor.gRed),
                            )
                          ],
                        ),
                      ),
                      child: Visibility(
                        visible: isTherapist,
                        replacement: RowText(
                          Icons.location_on,
                          basicInfo.location,
                        ),
                        child: RowText(
                          basicInfo.organizationName != null &&
                                  basicInfo.organizationName!.isNotEmpty
                              ? Icons.factory_outlined
                              : Icons.location_on,
                          basicInfo.organizationName ?? basicInfo.location,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Divider(
              color: AppColor.lightGrey,
            ),
            Visibility(
              visible: canShowDetails,
              child: Wrap(
                runSpacing: 12,
                spacing: 12,
                children: [
                  // if (user.type == 'Clinic' ||
                  //     Global.isAdmin ||
                  //     Global.status == 'APPROVED')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RowText(
                        Icons.mail,
                        basicInfo.email,
                        color: Colors.red,
                        onTap: () async {
                          Uri url = Uri.parse(
                              'mailto:${basicInfo.email}?subject=Greetings from KMC&body=Hello ${basicInfo.name},\n\n');
                          await launchUrl(url);
                        },
                      ),
                    ],
                  ),
                  // if ((Global.isGuest || Global.status == 'PENDING') &&
                  //     !Global.isAdmin &&
                  //     isTherapist)
                  // if (Global.isAdmin || user.type == 'Clinic')
                  RowText(
                    Icons.phone,
                    basicInfo.phone,
                    color: Colors.green,
                    onTap: () async {
                      Uri url = Uri.parse('tel:${basicInfo.phone}');
                      await launchUrl(url);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function? onTap;
  final MaterialColor? color;
  const RowText(
    this.iconData,
    this.title, {
    this.color = Colors.red,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return onTap != null
        ? TextButton(
            style: TextButton.styleFrom(
              backgroundColor: color!.shade300,
            ),
            onPressed: () async {
              Uri url = Uri.parse('tel:+919585447986');
              await launchUrl(url);
            },
            child: mainWidget(context),
          )
        : mainWidget(context);
  }

  Row mainWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: color?.shade600 ?? Colors.orange,
          size: 16,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
              ),
        ),
      ],
    );
  }
}
