import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ot_registration/app/constants/arguments.dart';
import 'package:ot_registration/app/helper/services/navigator.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/modules/profile_settings/banner_manager.dart';
import 'package:ot_registration/presentation/app_user/modules/user_preview/widgets/app_user_details.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final UserRepo userRepo = getIt.get<UserRepo>();
  final trailingIcon = Icon(
    Icons.arrow_forward_ios,
    color: Colors.black54,
    size: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            if (userRepo.isAdmin)
              SettingsContainer(
                title: 'Manage',
                children: [
                  ListTile(
                    trailing: trailingIcon,
                    title: Text('Update Banners'),
                    onTap: () async => await CustomNav.navigateBackWidget(
                      context,
                      BannerManagementPage(),
                    ),
                  ),
                  // ListTile(
                  //   title: Text('Update Organization Info'),
                  //   onTap: () async => await CustomNav.navigateBack(
                  //     context,
                  //     Routes.register,
                  //     arguments: {
                  //       CustomArgument.isUpdateProfile: true,
                  //       CustomArgument.isOrganization: true,
                  //     },
                  //   ),
                  //   enabled: userRepo.user.isOrganization,
                  // ),
                ],
              ),

            if (!userRepo.isAdmin)
              SettingsContainer(
                title: 'Account',
                children: [
                  // view profile
                  ListTile(
                    trailing: trailingIcon,
                    title: Text('View Profile'),
                    onTap: () async => await CustomNav.navigateBackWidget(
                      context,
                      Scaffold(
                        appBar: AppBar(
                          title: Text('Profile'),
                        ),
                        body: AppUserPage(
                          user: userRepo.user,
                          repo: userRepo,
                          onAccessChanged: (p0) {},
                          isTherapist: true,
                        ),
                      ),
                    ),
                    enabled: userRepo.user.isTherapist,
                  ),
                  ListTile(
                    trailing: trailingIcon,
                    title: Text('Update Therapist Info'),
                    onTap: () async => await CustomNav.navigateBack(
                      context,
                      Routes.register,
                      arguments: {
                        CustomArgument.isUpdateProfile: true,
                        CustomArgument.isTherapist: true,
                      },
                    ),
                    enabled: userRepo.user.isTherapist,
                  ),
                  ListTile(
                    trailing: trailingIcon,
                    title: Text('View Profile'),
                    onTap: () async => await CustomNav.navigateBackWidget(
                      context,
                      Scaffold(
                        appBar: AppBar(
                          title: Text('Profile'),
                        ),
                        body: AppUserPage(
                          user: userRepo.user,
                          repo: userRepo,
                          onAccessChanged: (p0) {},
                          isTherapist: false,
                        ),
                      ),
                    ),
                    enabled: userRepo.user.isOrganization,
                  ),
                  ListTile(
                    trailing: trailingIcon,
                    title: Text('Update Organization Info'),
                    onTap: () async => await CustomNav.navigateBack(
                      context,
                      Routes.register,
                      arguments: {
                        CustomArgument.isUpdateProfile: true,
                        CustomArgument.isOrganization: true,
                      },
                    ),
                    enabled: userRepo.user.isOrganization,
                  ),
                ],
              ),

            // SettingsContainer(
            //   title: 'Notifications',
            //   children: [
            //     ListTile(
            //       title: Text('Push Notifications'),
            //       trailing: Switch(
            //         value: true,
            //         onChanged: (value) {},
            //       ),
            //     ),
            //     ListTile(
            //       title: Text('Email Notifications'),
            //       trailing: Switch(
            //         value: true,
            //         onChanged: (value) {},
            //       ),
            //     ),
            //   ],
            // ),

            SettingsContainer(
              title: 'Privacy',
              children: [
                ListTile(
                  trailing: trailingIcon,
                  title: Text('Privacy Policy'),
                  onTap: () {},
                ),
                ListTile(
                  trailing: trailingIcon,
                  title: Text('Terms of Use'),
                  onTap: () {},
                ),
              ],
            ),
            SettingsContainer(
              title: 'About',
              children: [
                ListTile(
                  trailing: trailingIcon,
                  title: Text('About Us'),
                  onTap: () {},
                ),
                ListTile(
                  trailing: trailingIcon,
                  title: Text('Contact Us'),
                  onTap: () {},
                ),
              ],
            ),
            SettingsContainer(
              title: 'Logout',
              children: [
                ListTile(
                  title: Text('Logout'),
                  onTap: () async {
                    if (kDebugMode) {
                      await userRepo.signOut(context);
                      return;
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await userRepo.signOut(context);
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SettingsContainer(
      {required this.title, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
