import 'package:flutter/material.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/presentation/blog/widgets/blog_item.dart';

import '../../../app/helper/widgets/shimmer_card.dart';

class RecentBlogBuilder extends StatelessWidget {
  final List<Blog> blogs;
  final bool isLoading;
  const RecentBlogBuilder(
      {super.key, required this.blogs, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 60),
      itemCount: isLoading ? 2 : blogs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return isLoading ? ShimmerCard() : BlogItem(blog: blogs[index]);
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 20);
      },
    );
  }
}
