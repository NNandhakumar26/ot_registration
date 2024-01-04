import 'package:flutter/material.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/data/model/blog.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';

class BlogItem extends StatelessWidget {
  final Blog blog;
  const BlogItem({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.blogDetail, arguments: blog);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog.image != null)
              Container(
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(blog.image!))),
              ),
            if (blog.title != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  blog.title!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColor.darkGrey),
                ),
              ),
            if (blog.content != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Text(
                  blog.content!,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black54,
                      ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
