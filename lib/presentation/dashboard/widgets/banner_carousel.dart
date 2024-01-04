import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ot_registration/helper/utils/shimmer.dart';

class BannerCarousel extends StatelessWidget {
  final List images;
  final bool isLoading;
  const BannerCarousel(
      {super.key, required this.images, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 160.0, autoPlay: true),
      items: images.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.grey.withOpacity(0.4),
                    enabled: true,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        )))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              imageUrl,
                            ))));
          },
        );
      }).toList(),
    );
  }
}
