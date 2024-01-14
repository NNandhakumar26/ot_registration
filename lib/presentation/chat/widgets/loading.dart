import 'package:flutter/material.dart';
import 'package:ot_registration/helper/utils/constants.dart';
import 'package:ot_registration/app/helper/widgets/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  final String type;

  const LoadingWidget({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.grey.withOpacity(0.4),
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: type != Constants.shimmer_1 ? 100 : 90,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
            ),
            if (type != Constants.shimmer_1)
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: type == Constants.shimmer_3 ? 35 : 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            if (type != Constants.shimmer_1)
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: type == Constants.shimmer_3 ? 15 : 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            if (type == Constants.shimmer_3)
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: 15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            if (type == Constants.shimmer_3)
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: 15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            if (type == Constants.shimmer_3)
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                height: 15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
          ],
        ));
  }
}
