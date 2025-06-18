import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Theme/theme.dart';
import '../../Models/news_card.dart';

class BlogDetailsView extends StatelessWidget {
  final Article article;

  const BlogDetailsView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog & News",
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: article.content.isEmpty
          ? Center(
        child: Text(
          "localProvider.getValue('noContentAvailable') ?? 'No content available'",
          style: TextStyle(fontSize: 16.sp),
        ),
      )
          : ListView.builder(
        padding: REdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: article.content.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: REdgeInsets.all(12),
                  child: Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: MyTheme.lightBlue,
                    ),
                  ),
                ),
                if (article.image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r),
                      bottom: Radius.circular(12.r),
                    ),
                    child: Image.asset(
                      article.image,
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 30.h),
              ],
            );
          }

          final section = article.content[index - 1];

          return Padding(
            padding: REdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.heading != null && section.heading!.isNotEmpty)
                  Text(
                    section.heading!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: MyTheme.lightBlue,

                    ),
                  ),
                if (section.image != null && section.image!.isNotEmpty)
                  Padding(
                    padding: REdgeInsets.symmetric(vertical: 10.h),
                    child: Image.asset(
                      section.image!,
                      fit: BoxFit.cover,
                      height: 150.h,
                      width: double.infinity,
                    ),
                  ),
                if (section.body.isNotEmpty)
                  Padding(
                    padding: REdgeInsets.only(top: 8.h),
                    child: Text(
                      section.body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                        color: MyTheme.lightBlue,

                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}