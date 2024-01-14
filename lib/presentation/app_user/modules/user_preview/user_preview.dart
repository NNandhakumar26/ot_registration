import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ot_registration/app/enum/access.dart';
import 'package:ot_registration/app/helper/widgets/shimmer_card.dart';
import 'package:ot_registration/data/model/app_user.dart';
import 'package:ot_registration/data/network/utils/network.dart';
import 'package:ot_registration/helper/utils/toast.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/modules/user_preview/widgets/app_user_card.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

class UserListView extends StatelessWidget {
  final Access access;
  final bool viewTherapistPage;

  const UserListView({
    required this.access,
    this.viewTherapistPage = true,
    super.key,
  });

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Therapist'),
    Tab(text: 'Clinic'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: viewTherapistPage ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User List'),
          bottom: const TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            LoadUser(
              access: access,
              isTherapist: true,
            ),
            LoadUser(
              access: access,
              isTherapist: false,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadUser extends StatefulWidget {
  final bool isTherapist;
  final Access access;
  const LoadUser({super.key, required this.access, required this.isTherapist});

  @override
  State<LoadUser> createState() => _LoadUserState();
}

class _LoadUserState extends State<LoadUser>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;
  String? errorMessage;

  List<AppUser> userList = [];
  UserRepo userRepo = getIt.get<UserRepo>();

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      String accessName =
          widget.isTherapist ? 'therapistAccess' : 'organizationAccess';

      return await Network.ref.userDB
          .where(accessName, isEqualTo: widget.access.name)
          .get()
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
            userList = value.docs
                .map((e) => AppUser.fromMap(e.data()! as Map<String, dynamic>))
                .toList();
          }
        },
      );
    } catch (e) {
      errorMessage = e.toString();
      throw e;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return loading
        ? ShimmerCard()
        : errorMessage != null
            ? Center(
                child: Text(errorMessage!),
              )
            : RefreshIndicator(
                onRefresh: loadUsers,
                child: userList.isNotEmpty
                    ? ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return AppUserCard(
                            user: userList[index],
                            userRepo: userRepo,
                            isTherapist: widget.isTherapist,
                            onAccessChanged: (access) async {
                              setState(() {
                                userList[index].therapistAccess = access;
                              });

                              showDialog(
                                context: context,
                                builder: (builder) => AlertDialog(
                                  title: Text('Updating Access'),
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text('Updating, Please wait...'),
                                    ],
                                  ),
                                ),
                              );

                              await Network.ref.userDB
                                  .doc(userList[index].userId)
                                  .update(
                                    widget.isTherapist
                                        ? {
                                            'therapistAccess': access.name,
                                          }
                                        : {
                                            'organizationAccess': access.name,
                                          },
                                  );
                              setState(() {
                                userList.removeAt(index);
                              });
                              Navigator.pop(context);
                              showToast(
                                context,
                                message: 'Access Updated',
                                success: true,
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.clockRotateLeft,
                              size: 64,
                              color: Colors.black26,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Text(
                              'Oops..! No Data Found.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black45,
                                  ),
                            ),
                          ],
                        ),
                      ),
              );
  }
}
