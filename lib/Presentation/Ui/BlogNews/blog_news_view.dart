import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import 'blog_details_view.dart';
import 'blog_news_navigator.dart';
import 'blog_news_view_model.dart';

class BlogNewsView extends StatefulWidget {

  const BlogNewsView({super.key});

  @override
  State<BlogNewsView> createState() => _BlogNewsViewState();
}

class _BlogNewsViewState extends BaseState<BlogNewsView, BlogNewsViewModel>
    implements BlogNewsNavigator {

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final langCode = getLanguageCode();
      viewModel.loadArticles(langCode: langCode);
    });
  }

  String getLanguageCode() {
    try {
      final locale = Localizations.localeOf(context);
      return locale.languageCode == 'ar' ? 'ar' : 'en';
    } catch (e) {
      return 'en';
    }
  }

  bool isDarkTheme() {
    try {
      return Theme.of(context).brightness == Brightness.dark;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BlogNewsViewModel>(
      create: (_) => viewModel,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: REdgeInsets.all(16.w),
            child: Consumer<BlogNewsViewModel>(
              builder: (context, vm, child) {
                if (vm.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.r,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          vm.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {
                            final langCode = getLanguageCode();
                            vm.loadArticles(langCode: langCode);
                          },
                          child: Text(
                            'Retry',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (vm.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                    ),
                  );
                }

                if (vm.articles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 64.r,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No articles available',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'News & Blogs',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: isDarkTheme() ? MyTheme.white : MyTheme.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          final langCode = getLanguageCode();
                          return vm.loadArticles(langCode: langCode);
                        },
                        child: ListView.builder(
                          itemCount: vm.articles.length,
                          itemBuilder: (_, index) {
                            final article = vm.articles[index];
                            return GestureDetector(
                              onTap: () => vm.goToDetails(article.id),
                              child: Card(
                                margin: REdgeInsets.only(bottom: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (article.image.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12.r),
                                        ),
                                        child: Image.asset(
                                          article.image,
                                          height: 180.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 180.h,
                                              width: double.infinity,
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 50.r,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    Padding(
                                      padding: REdgeInsets.all(12.w),
                                      child: Text(
                                        article.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: MyTheme.lightBlue,
                                          fontSize: 18.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  BlogNewsViewModel initViewModel() => BlogNewsViewModel();

  @override
  void goToArticleDetails(int articleId) {
    final article = viewModel.articles.firstWhere((a) => a.id == articleId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BlogDetailsView(article: article)),
    );
  }
}