import 'package:flutter/material.dart';

import 'package:ot_registration/app/resources/color_manager.dart';

class EmptyItem extends StatelessWidget {
  final String message;
  const EmptyItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
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
      child: Column(
        children: [
          Text(
            'NO DATA',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 20,
          ),
          Icon(
            Icons.hourglass_empty,
            color: AppColor.primary,
            size: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.grey)))
        ],
      ),
    );
  }
}
