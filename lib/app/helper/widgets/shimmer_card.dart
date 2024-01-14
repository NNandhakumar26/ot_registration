import 'package:flutter/material.dart';
import 'package:ot_registration/app/helper/widgets/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  ShimmerCard({
    super.key,
  });

  final Widget dummyContainer = Container(
    width: double.infinity,
    height: 150, // Adjust height as needed
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final Widget container2 = Card(
    child: Container(
      width: double.infinity * 0.8,
      height: 150, // Adjust height as needed
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      // baseColor: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
      // highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),

      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < 5; i++) container2,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
