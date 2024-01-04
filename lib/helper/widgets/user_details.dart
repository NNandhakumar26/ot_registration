import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/data/model/user.dart';
import 'package:ot_registration/presentation/user/bloc/user_bloc.dart';

import 'package:ot_registration/helper/resources/color_manager.dart';

class UserDetails extends StatelessWidget {
  final User user;
  final BuildContext buildContext;
  final bool action;
  const UserDetails(
      {super.key,
      required this.user,
      required this.action,
      required this.buildContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 0),
                blurRadius: 8,
                spreadRadius: 4)
          ]),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (action)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 130,
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
                        onPressed: () {
                          buildContext
                              .read<UserBloc>()
                              .add(ChangeStatus(id: user.id));
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.64),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('APPROVE')
                          ],
                        )),
                  )
                ],
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                width: 12,
              ),
              Flexible(
                  child: Text(user.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: AppColor.primary))),
            ],
          ),
          if (user.type == 'Clinic' && user.organizationType != null)
            const Divider(color: Colors.transparent, height: 30),
          if (user.type == 'Clinic' && user.organizationType != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('Organization Type',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.grey)),
            ),
          if (user.type == 'Clinic' && user.organizationType != null)
            Text(user.organizationType!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 16)),
          if (user.type == 'Clinic' && user.organizationHead != null)
            const Divider(color: Colors.transparent, height: 30),
          if (user.type == 'Clinic' && user.organizationHead != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('Organization Head',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.grey)),
            ),
          if (user.type == 'Clinic' && user.organizationHead != null)
            Text(user.organizationHead!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 16)),
          if (user.type == 'Therapist')
            const Divider(color: Colors.transparent, height: 30),
          if (user.type == 'Therapist')
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('Age',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.grey)),
                    ),
                    Text(user.age!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 16)),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('Gender',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.grey)),
                    ),
                    Text(
                      user.gender!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ))
              ],
            ),
          if (user.type == 'Therapist')
            const Divider(color: Colors.transparent, height: 30),
          if (user.type == 'Therapist')
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('Designation',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.grey)),
                    ),
                    Text(user.designation!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 16)),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('Studied BOT At',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.grey)),
                    ),
                    Text(
                      user.botAt!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ))
              ],
            ),
          if (user.type == 'Therapist')
            const Divider(color: Colors.transparent, height: 40),
          if (user.type == 'Therapist')
            OutlinedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, Routes.pdfView,
                      arguments: user.certificate);
                },
                child: const Text('Certificate')),
          if (user.type == 'Therapist')
            const Divider(color: Colors.transparent, height: 40),
          if (user.type == 'Therapist')
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('AIOTA Membership',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.grey)),
                    ),
                    Text(user.aiota!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 16)),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('Qualifications',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.grey)),
                    ),
                    Text(
                      user.other!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ))
              ],
            ),
          const Divider(color: Colors.transparent, height: 30),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('Mobile',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColor.grey)),
                  ),
                  Text(
                    user.phone,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 16),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('Email',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColor.grey)),
                  ),
                  Text(user.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 16)),
                ],
              ))
            ],
          ),
          if (user.type == 'Clinic')
            const Divider(color: Colors.transparent, height: 30),
          if (user.type == 'Clinic')
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Serivices',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.grey)),
            ),
          if (user.type == 'Clinic')
            SizedBox(
              width: double.infinity,
              child: DataTable(
                border: TableBorder.all(color: AppColor.borderGrey),
                headingRowColor: MaterialStateProperty.all(AppColor.borderGrey),
                columns: [
                  DataColumn(
                      label: Text(
                    'Service',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                  DataColumn(
                      label: Text('Charge',
                          style: Theme.of(context).textTheme.bodyText1)),
                ],
                rows: user.services.map((e) {
                  return DataRow(cells: [
                    DataCell(Text(e['service'])),
                    DataCell(Text(e['charge']))
                  ]);
                }).toList(),
              ),
            ),
          if (user.type == 'Clinic')
            const Divider(color: Colors.transparent, height: 30),
          if (user.type == 'Clinic')
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('Working Hours',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.grey)),
            ),
          if (user.type == 'Clinic')
            Text(user.workingHours!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 16)),
          const Divider(color: Colors.transparent, height: 30),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Address',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          Text(user.address,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 16)),
          if (user.type == 'Clinic')
            const Divider(color: Colors.transparent, height: 30),
          if (user.type == 'Clinic' && user.website != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('Website',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.grey)),
            ),
          if (user.type == 'Clinic' && user.website != null)
            if (user.type == 'Clinic')
              Text(user.website!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 16))
        ],
      ),
    );
  }
}
