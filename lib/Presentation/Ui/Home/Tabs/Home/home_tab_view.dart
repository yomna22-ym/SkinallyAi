import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Add this import
import '../../../../../Core/Base/base_state.dart';
import '../../../../../Core/Theme/theme.dart';
import '../../../../../Core/routes_manager/routes.dart';
import 'home_tab_navigator.dart';
import 'home_tab_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends BaseState<HomeTabView, HomeTabViewModel>
    implements HomeTabNavigator {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  HomeTabViewModel initViewModel() => HomeTabViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final langCode = Localizations.localeOf(context).languageCode;
      viewModel.loadRecommendedCategories();
      viewModel.loadArticles(langCode: langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<HomeTabViewModel>(
        builder:
            (context, vm, _) => SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Text(
                              vm.getGreetingMessage(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color:
                                    viewModel.themeProvider!.isDark()
                                        ? Colors.white70
                                        : Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            vm.isLoading
                                ? Container(
                                  height: 28.h,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    color:
                                        viewModel.themeProvider!.isDark()
                                            ? Colors.white24
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                )
                                : Text(
                                  vm.getWelcomeMessage(),
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color:
                                        viewModel.themeProvider!.isDark()
                                            ? Colors.white
                                            : MyTheme.lightBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // Enhanced AI Assistant Card with Slider (without indicators)
                      Container(
                        margin: REdgeInsets.symmetric(horizontal: 20),
                        height: 250.h,
                        // Reduced height since indicators are moved
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              MyTheme.lightBlue,
                              MyTheme.lightBlue.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: MyTheme.lightBlue.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: [
                            _buildSliderPage(
                              title:
                                  viewModel.localProvider!.isEn()
                                      ? 'Start uploading your affected area now!'
                                      : 'ابدأ برفع المنطقة المصابة الآن!',

                              subtitle:
                                  viewModel.localProvider!.isEn()
                                      ? 'Upload a clear photo for accurate diagnosis'
                                      : 'ارفع صورة واضحة للحصول على تشخيص دقيق',
                              buttonText:
                                  viewModel.localProvider!.isEn()
                                      ? 'Upload'
                                      : 'رفع',
                              lottieAsset: 'Assets/Animations/upld.json',
                              onPressed:
                                  () => vm.handleUploadButtonPressed(context),
                            ),
                            _buildSliderPage(
                              title:
                                  viewModel.localProvider!.isEn()
                                      ? 'Ask Our AI Assistant'
                                      : 'افحص بشرتك الآن',
                              subtitle:
                                  viewModel.localProvider!.isEn()
                                      ? 'Get instant AI analysis of your skin condition'
                                      : 'احصل على تحليل فوري بالذكاء الاصطناعي لحالة بشرتك',
                              buttonText:
                                  viewModel.localProvider!.isEn()
                                      ? 'Start Analysis'
                                      : 'ابدأ التحليل',
                              lottieAsset: 'Assets/Animations/llm.json',
                              onPressed: () => _showUploadMessage(context),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // External Page Indicators - positioned between Upload section and Categories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPageIndicator(_currentPage == 0),
                          SizedBox(width: 8.w),
                          _buildPageIndicator(_currentPage == 1),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Categories Section
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              viewModel.localProvider!.isEn()
                                  ? 'Our Categories'
                                  : 'فئاتنا',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color:
                                    viewModel.themeProvider!.isDark()
                                        ? MyTheme.white
                                        : MyTheme.lightBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Enhanced Categories Grid
                      vm.isLoadingCategories
                          ? SizedBox(
                            height: 200.h,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: MyTheme.lightBlue,
                              ),
                            ),
                          )
                          : vm.recommendedCategories.isEmpty
                          ? SizedBox(
                            height: 200.h,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.category,
                                    size: 48.w,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    viewModel.localProvider!.isEn()
                                        ? 'No categories available'
                                        : 'لا توجد فئات متاحة',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 220.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: REdgeInsets.symmetric(horizontal: 20),
                              itemCount:
                                  vm.recommendedCategories.length > 8
                                      ? 9
                                      : vm.recommendedCategories.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 8 ||
                                    index == vm.recommendedCategories.length) {
                                  return Container(
                                    width: 120.w,
                                    margin: REdgeInsets.only(right: 12),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap:
                                              () =>
                                                  vm.navigateToCategoriesView(),
                                          child: Container(
                                            width: 120.w,
                                            height: 120.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  MyTheme.lightBlue,
                                                  MyTheme.lightBlue.withOpacity(
                                                    0.7,
                                                  ),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: MyTheme.lightBlue
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 35.w,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          viewModel.localProvider!.isEn()
                                              ? 'View All'
                                              : 'عرض الكل',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                viewModel.themeProvider!
                                                        .isDark()
                                                    ? Colors.white
                                                    : Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final category =
                                    vm.recommendedCategories[index];
                                return Container(
                                  width: 120.w,
                                  margin: REdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap:
                                        () => vm.navigateToCategoryDetails(
                                          category,
                                        ),
                                    child: Column(
                                      children: [
                                        // Enhanced Circular Category Image
                                        Container(
                                          width: 120.w,
                                          height: 120.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[200],
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.3,
                                                ),
                                                spreadRadius: 3,
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child:
                                                category['image'] != null &&
                                                        category['image']
                                                            .toString()
                                                            .isNotEmpty
                                                    ? Image.asset(
                                                      category['image'],
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[200],
                                                          child: Icon(
                                                            Icons.category,
                                                            size: 40.w,
                                                            color:
                                                                Colors
                                                                    .grey[400],
                                                          ),
                                                        );
                                                      },
                                                    )
                                                    : Container(
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons.category,
                                                        size: 40.w,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        // Category Name
                                        Text(
                                          category['name']?.toString() ??
                                              (viewModel.localProvider!.isEn()
                                                  ? 'Unknown Category'
                                                  : 'فئة غير معروفة'),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                viewModel.themeProvider!
                                                        .isDark()
                                                    ? Colors.white
                                                    : Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                      SizedBox(height: 10.h),
                      // FAQ Section

                      // Blog Section
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.localProvider!.isEn()
                                  ? 'You can find some interesting things here'
                                  : 'أحدث المقالات',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color:
                                    viewModel.themeProvider!.isDark()
                                        ? MyTheme.white
                                        : MyTheme.lightBlue,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildBlogSection(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.localProvider!.isEn()
                                  ? 'Frequently Asked Questions'
                                  : 'الأسئلة الشائعة',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color:
                                    viewModel.themeProvider!.isDark()
                                        ? MyTheme.white
                                        : MyTheme.lightBlue,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildFAQGrid(),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildSliderPage({
    required String title,
    required String subtitle,
    required String buttonText,
    required String lottieAsset,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: REdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              // Lottie Animation Container
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Lottie.asset(
                    lottieAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 45.w,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: MyTheme.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: 5,
              ),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      width: isActive ? 20.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? MyTheme.lightBlue : Colors.grey[400],
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildFAQGrid() {
    final faqItems = [
      {
        'icon': Icons.medical_services_rounded,
        'title':
            viewModel.localProvider!.isEn()
                ? 'Early Detection'
                : 'الكشف المبكر',
        'color': Colors.purple,
        'onTap': () => Navigator.pushNamed(context, '/faq-early-detection'),
      },
      {
        'icon': Icons.psychology_rounded,
        'title':
            viewModel.localProvider!.isEn()
                ? 'AI Information'
                : 'معلومات الذكاء الاصطناعي',
        'color': MyTheme.lightBlue,
        'onTap': () => Navigator.pushNamed(context, '/faq-ai-info'),
      },
      {
        'icon': Icons.people_rounded,
        'title':
            viewModel.localProvider!.isEn()
                ? 'Who Should Use'
                : 'من يجب أن يستخدم',
        'color': Colors.green,
        'onTap': () => Navigator.pushNamed(context, '/faq-who-should-use'),
      },
      {
        'icon': Icons.security_rounded,
        'title':
            viewModel.localProvider!.isEn()
                ? 'Privacy & Safety'
                : 'الخصوصية والأمان',
        'color': Colors.orange,
        'onTap': () => Navigator.pushNamed(context, '/faq-privacy'),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: faqItems.length,
      itemBuilder: (context, index) {
        final item = faqItems[index];
        return GestureDetector(
          onTap: item['onTap'] as VoidCallback,
          child: Container(
            decoration: BoxDecoration(
              color:
                  viewModel.themeProvider!.isDark()
                      ? Colors.grey[800]
                      : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: (item['color'] as Color).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 30.w,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          viewModel.themeProvider!.isDark()
                              ? Colors.white
                              : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlogSection() {
    if (viewModel.isLoadingArticles) {
      return Center(child: CircularProgressIndicator(color: MyTheme.lightBlue));
    }

    final blogs = viewModel.articles.take(5).toList();

    if (blogs.isEmpty) {
      return Text(
        viewModel.localProvider!.isEn()
            ? 'No blog posts available.'
            : 'لا توجد مقالات متاحة.',
        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        SizedBox(
          height: 280.h,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return Container(
                margin: REdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                  color:
                      viewModel.themeProvider!.isDark()
                          ? Colors.grey[800]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                      child: Image.asset(
                        blog.image,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180.h,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50.w,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: REdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color:
                                    viewModel.themeProvider!.isDark()
                                        ? Colors.white
                                        : Colors.black87,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                blogs.length,
                                (dotIndex) => Container(
                                  width: dotIndex == index ? 12.w : 8.w,
                                  height: 8.h,
                                  margin: REdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        dotIndex == index
                                            ? MyTheme.lightBlue
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: SizedBox(
            width: double.infinity,
            height: 50.h,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.blogNewsRoute);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: MyTheme.lightBlue, width: 2.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                backgroundColor: Colors.transparent,
              ),
              child: Text(
                viewModel.localProvider!.isEn()
                    ? 'Read other articles'
                    : 'اقرأ مقالات أخرى',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: MyTheme.lightBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getBlogPosts() {
    return [
      {
        'title':
            viewModel.localProvider!.isEn()
                ? '5 Reasons to start Mole-mapping'
                : '5 أسباب لبدء رسم خريطة الشامات',
        'image': 'Assets/blogs/mole_mapping.jpg',
        'id': 1,
      },
      {
        'title':
            viewModel.localProvider!.isEn()
                ? 'AI-Powered Skin Cancer Detection'
                : 'اكتشاف سرطان الجلد بالذكاء الاصطناعي',
        'image': 'Assets/blogs/ai_detection.jpg',
        'id': 2,
      },
      {
        'title':
            viewModel.localProvider!.isEn()
                ? 'Understanding Melanoma Risks'
                : 'فهم مخاطر الميلانوما',
        'image': 'Assets/blogs/melanoma_risks.jpg',
        'id': 3,
      },
      {
        'title':
            viewModel.localProvider!.isEn()
                ? 'Preventive Skincare Tips'
                : 'نصائح العناية الوقائية بالبشرة',
        'image': 'Assets/blogs/skincare_tips.jpg',
        'id': 4,
      },
    ];
  }

  void _showUploadMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          title: Text(
            viewModel.localProvider!.isEn() ? 'AI Assistant' : 'مساعد ذكي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyTheme.lightBlue,
            ),
          ),
          content: Text(
            viewModel.localProvider!.isEn()
                ? 'Please upload your affected area first to get help from AI'
                : 'يرجى تحميل المنطقة المصابة أولاً للحصول على المساعدة من الذكاء الاصطناعي',
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                viewModel.localProvider!.isEn() ? 'OK' : 'موافق',
                style: TextStyle(
                  color: MyTheme.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  void navigateToPharmacyView() {
    Navigator.pushNamed(context, Routes.pharmacyRoute);
  }

  @override
  void navigateToCategoriesView() {
    Navigator.pushNamed(context, Routes.categoryViewRoute);
  }

  @override
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void navigateToCategoryDetails(category) {
    // Navigate to category details
  }
}
