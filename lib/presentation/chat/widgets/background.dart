import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ot_registration/helper/resources/appconfig.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';

class Background extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final AppBar? appBar;
  final bool isBackPressed;
  final VoidCallback? onBackPress;
  final String? title;
  final List<Widget> actions;

  const Background(
      {Key? key,
      required this.child,
      this.title,
      this.appBar,
      this.isBackPressed = false,
      this.padding = const EdgeInsets.all(0),
      this.actions = const [],
      this.onBackPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConfig.primaryLight,
        appBar: isBackPressed
            ? AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(FontAwesomeIcons.arrowLeft, size: 26),
                    onPressed: onBackPress ?? () => Navigator.pop(context),
                    splashRadius: 20,
                  ),
                ),
                actions: actions,
                title: title != null
                    ? Text(
                        title!,
                        style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 22),
                      ).tr()
                    : null,
              )
            : appBar,
        body: SafeArea(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ));
  }
}
