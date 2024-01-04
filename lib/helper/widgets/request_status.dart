import 'package:flutter/material.dart';

import 'package:ot_registration/helper/resources/color_manager.dart';

class RequestStatus extends StatelessWidget {
  const RequestStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 0),
                    blurRadius: 8,
                    spreadRadius: 4)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Request is Pending',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: 20,
              ),
              Icon(
                Icons.pending_actions,
                color: AppColor.primary,
                size: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: Text(
                      'Waiting for admins approval. Your details & documents will be verified by admin.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: AppColor.grey)))
            ],
          ),
        ),
      ),
    );
  }
}
