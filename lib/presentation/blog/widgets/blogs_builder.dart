import 'package:flutter/material.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/presentation/blog/widgets/blog_item.dart';

import '../../../helper/widgets/shimmer_card.dart';

class BlogsBuilder extends StatelessWidget {
  final List<Blog> blogs;
  final bool isLoading;
  final bool isPaging;
  final ScrollController controller;
  const BlogsBuilder(
      {super.key,
      required this.blogs,
      required this.isLoading,
      required this.isPaging,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 60),
      itemCount: isLoading ? 2 : blogs.length,
      controller: controller,
      itemBuilder: (_, index) {
        return isLoading
            ? const ShimmerCard()
            : Column(
                children: [
                  BlogItem(blog: blogs[index]),
                  if (index == blogs.length - 1 && isPaging)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ShimmerCard(),
                    )
                ],
              );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 20);
      },
    );
  }
}
