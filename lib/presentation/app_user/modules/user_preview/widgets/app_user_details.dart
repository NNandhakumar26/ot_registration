import 'package:flutter/material.dart';
import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/app/helper/services/navigator.dart';
import 'package:ot_registration/data/model/app_user.dart';
import 'package:ot_registration/data/model/basic_info.dart';
import 'package:ot_registration/data/model/therapist.dart';
import 'package:ot_registration/data/model/therapy_center.dart';
import 'package:ot_registration/data/network/utils/network.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppUserPage extends StatefulWidget {
  final AppUser user;
  final UserRepo repo;
  final bool isTherapist;
  final Function(Access) onAccessChanged;

  const AppUserPage({
    super.key,
    required this.user,
    required this.repo,
    required this.isTherapist,
    required this.onAccessChanged,
  });

  @override
  State<AppUserPage> createState() => _AppUserPageState();
}

class _AppUserPageState extends State<AppUserPage> {
  BasicInfo get basicInfo => widget.isTherapist
      ? widget.user.therapistInfo!
      : widget.user.organizationInfo!;

  Access get access => widget.isTherapist
      ? widget.user.therapistAccess!
      : widget.user.organizationAccess!;

  bool isLoading = false;
  String? errorMessage;

  // late Therapist? thisTherapist;
  // late Organization? thisOrganization;

  late Therapist therapist;
  late Organization organization;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future loadUser() async {
    if (isLoading) {
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });

      if (widget.isTherapist) {
        therapist = await Network.getTherapist(widget.user.userId!);
      } else {
        organization = await Network.getOrganization(widget.user.userId!);
      }
    } on Exception catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 0),
                    blurRadius: 8,
                    spreadRadius: 4)
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.repo.isAdmin)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: (access != Access.denied),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onAccessChanged(Access.denied);

                              // context.read<UserBloc>().add(
                              //       ChangeStatus(
                              //         id: widget.user.userId!,
                              //       ),
                              //     )
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.64),
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Deny')
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: access != Access.approved,
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onAccessChanged(Access.approved);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  // color: Theme.of(context)
                                  // .primaryColor
                                  // .withOpacity(0.64),
                                  color: Colors.white60,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('APPROVE')
                              ],
                            ),
                          ),
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
                      backgroundColor: widget.user.isTherapist
                          ? Colors.cyan.withOpacity(0.1)
                          : Colors.blueAccent.withOpacity(0.1),
                      child: Icon(
                          widget.user.isTherapist
                              ? Icons.person
                              : Icons.local_hospital,
                          color: widget.user.isTherapist
                              ? Colors.cyan.withOpacity(0.4)
                              : Colors.blueAccent.withOpacity(0.4)),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: Text(
                        basicInfo.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
                if (widget.user.isOrganization &&
                    organization.organizationType != null)
                  DisplayUtil(
                    'Organization Type',
                    organization.organizationType!,
                  ),
                if (widget.user.isOrganization &&
                    organization.organizationHead != null)
                  DisplayUtil(
                    'Organization Head',
                    organization.organizationHead!,
                  ),
                if (widget.user.isTherapist)
                  Column(
                    children: [
                      const Divider(color: Colors.transparent, height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: DisplayUtil(
                              'Age',
                              therapist.age!,
                              hideDivider: true,
                            ),
                          ),
                          Expanded(
                            child: DisplayUtil(
                              'Gender',
                              therapist.gender!,
                              hideDivider: true,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.transparent, height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: DisplayUtil(
                              'Designation',
                              therapist.designation!,
                              hideDivider: true,
                            ),
                          ),
                          Expanded(
                            child: DisplayUtil(
                              'Studied BOT @',
                              therapist.botAt!,
                              hideDivider: true,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.transparent, height: 40),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: StadiumBorder(),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(8),
                            // ),
                          ),
                          onPressed: () async {
                            CustomNav.navigateBackWidget(
                              context,
                              Scaffold(
                                body: Container(
                                  child: SfPdfViewer.network(
                                    therapist.certificate!,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text('View Certificate'),
                        ),
                      ),
                      const Divider(color: Colors.transparent, height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: DisplayUtil(
                              'AIOTA Membership',
                              therapist.aiotaMembership ?? '-',
                              hideDivider: true,
                            ),
                          ),
                          Expanded(
                            child: DisplayUtil(
                              'Qualifications',
                              therapist.other!,
                              hideDivider: true,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.transparent, height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: DisplayUtil(
                              'Mobile',
                              basicInfo.phone,
                              hideDivider: true,
                            ),
                          ),
                          Expanded(
                            child: DisplayUtil(
                              'Email',
                              basicInfo.email,
                              hideDivider: true,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.transparent, height: 30),
                      DisplayUtil(
                        'Address',
                        basicInfo.location,
                      ),
                    ],
                  ),
                if (widget.user.isOrganization)
                  Column(
                    children: [
                      const Divider(color: Colors.transparent, height: 30),
                      DisplayUtil(
                        'Services',
                        null,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          border: TableBorder.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.32),
                            width: 0.87,
                          ),
                          headingRowColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor.withOpacity(0.32)),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Service',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            DataColumn(
                                label: Text('Charge',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)),
                          ],
                          rows: organization.services!.map(
                            (e) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(e['service'])),
                                  DataCell(Text(e['charge']))
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      DisplayUtil(
                        'Working Hours',
                        organization.workingHours,
                      ),
                      DisplayUtil(
                        'Address',
                        basicInfo.location,
                      ),
                      DisplayUtil(
                        'Website',
                        organization.website,
                      )
                    ],
                  )
              ],
            ),
          );
  }
}

class DisplayUtil extends StatelessWidget {
  final String title;
  final String? value;
  final bool hideDivider;
  const DisplayUtil(
    this.title,
    this.value, {
    super.key,
    this.hideDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !hideDivider,
            child: const Divider(
              color: Colors.transparent,
              height: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.black.withOpacity(0.64),
                    fontSize: 14,
                  ),
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black.withOpacity(0.87),
                    fontSize: 16,
                  ),
            ),
        ],
      ),
    );
  }
}
