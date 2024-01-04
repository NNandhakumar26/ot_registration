import 'package:flutter/material.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';

class NoInternetView extends StatefulWidget {
  const NoInternetView({super.key});

  @override
  State<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends State<NoInternetView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/internet_disconnect.png'),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Connect To Internet',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: AppColor.grey),
          )
        ],
      ),
    );
  }
}
