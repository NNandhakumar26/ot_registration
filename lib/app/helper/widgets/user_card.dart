import 'package:flutter/material.dart';
import 'package:ot_registration/app/resources/color_manager.dart';
import 'package:ot_registration/data/model/custom_user.dart';
import 'package:ot_registration/helper/utils/global.dart';

class UserCard extends StatelessWidget {
  final CustomUser user;
  final VoidCallback? onClick;

  const UserCard({super.key, required this.user, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        // color: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          color: Colors.white70,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: user.type == 'Therapist'
                        ? Colors.cyan.withOpacity(0.1)
                        : Colors.blueAccent.withOpacity(0.1),
                    child: Icon(
                        user.type == 'Therapist'
                            ? Icons.person
                            : Icons.local_hospital,
                        color: user.type == 'Therapist'
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
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (user.type == 'Therapist')
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black54,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              user.organizationName ?? "Not Mentioned",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.black87,
                                  ),
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black54,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              user.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.black87,
                                  ),
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ),
              Divider(
                color: AppColor.lightGrey,
              ),
              Wrap(
                runSpacing: 12,
                spacing: 12,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (user.type == 'Clinic' ||
                      Global.isAdmin ||
                      Global.status == 'APPROVED')
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mail,
                          color: AppColor.grey,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColor.grey),
                        ),
                      ],
                    ),
                  if ((Global.isGuest || Global.status == 'PENDING') &&
                      !Global.isAdmin &&
                      user.type == 'Therapist')
                    Tooltip(
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
                          Text('Email Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColor.gRed))
                        ],
                      ),
                    ),
                  if (Global.isAdmin || user.type == 'Clinic')
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.phone,
                          color: AppColor.grey,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(user.phone,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColor.grey)),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
