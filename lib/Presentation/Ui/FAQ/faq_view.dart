import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import 'FAQ Details/faq_screen.dart';
import 'faq_navigator.dart';
import 'faq_view_model.dart';

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends BaseState<FAQView, FAQViewModel>
    with TickerProviderStateMixin
    implements FAQNavigator {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  FAQViewModel initViewModel() => FAQViewModel();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                viewModel.themeProvider!.isDark()
                    ? [
                      MyTheme.darkBlue.withOpacity(0.9),
                      MyTheme.darkBlue.withOpacity(0.7),
                    ]
                    : [MyTheme.lightBlue.withOpacity(0.1), MyTheme.white],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.local!.faq,
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium!.copyWith(
                          color:
                              viewModel.themeProvider!.isDark()
                                  ? MyTheme.offWhite
                                  : MyTheme.lightBlue,
                          fontSize: 42.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: MyTheme.lightBlue.withOpacity(0.3),
                              offset: Offset(2, 2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ListView.builder(
                        itemCount: _getFAQItems().length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds: 200 + (index * 100),
                            ),
                            curve: Curves.easeOutBack,
                            child: _buildFAQItem(
                              title: _getFAQItems()[index]['title'],
                              onTap: _getFAQItems()[index]['onTap'],
                              icon: _getFAQItems()[index]['icon'],
                              gradient: _getFAQItems()[index]['gradient'],
                              index: index,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFAQItems() {
    return [
      {
        'title': viewModel.local!.earlyDetection,
        'onTap': () => viewModel.onEarlyDetectionTap(this),
        'icon': Icons.medical_services_rounded,
        'gradient': [Colors.purple, Colors.purple.withOpacity(0.7)],
      },
      {
        'title': viewModel.local!.aiInfo,
        'onTap': () => viewModel.onSkinAllyAiTap(this),
        // Changed to use a Widget instead of IconData
        'icon': Image.asset(
          "Assets/Images/done skin.png",
          width: 24.w,
          height: 24.w,
          color: MyTheme.white, // This will tint the image white
        ),
        'gradient': [MyTheme.lightBlue, MyTheme.lightBlue.withOpacity(0.7)],
      },
      {
        'title': viewModel.local!.whoShouldUse,
        'onTap': () => viewModel.onWhoShouldUseTap(this),
        'icon': Icons.people_rounded,
        'gradient': [Colors.green, Colors.green.withOpacity(0.7)],
      },
      {
        'title': viewModel.local!.doesReplaceDoctor,
        'onTap': () => viewModel.onDoesReplaceDocTap(this),
        'icon': Icons.local_hospital_rounded,
        'gradient': [Colors.orange, Colors.orange.withOpacity(0.7)],
      },
      {
        'title': viewModel.local!.isInfoSafe,
        'onTap': () => viewModel.onPrivacyTap(this),
        'icon': Icons.security_rounded,
        'gradient': [Colors.red, Colors.red.withOpacity(0.7)],
      },
    ];
  }

  Widget _buildFAQItem({
    required String title,
    required VoidCallback onTap,
    required dynamic icon, // Changed from IconData to dynamic
    required List<Color> gradient,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withOpacity(0.3),
                    blurRadius: 15.r,
                    offset: Offset(0, 8.h),
                    spreadRadius: 2.r,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [MyTheme.white, MyTheme.white.withOpacity(0.9)],
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: gradient.first.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25.r),
                    onTap: onTap,
                    splashColor: gradient.first.withOpacity(0.2),
                    highlightColor: gradient.first.withOpacity(0.1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        children: [
                          // Icon container with support for both IconData and Widget
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: gradient.first.withOpacity(0.4),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child:
                                icon is IconData
                                    ? Icon(
                                      icon,
                                      color: MyTheme.white,
                                      size: 24.w,
                                    )
                                    : icon,
                          ),
                          SizedBox(width: 18.w),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: MyTheme.darkBlue,
                                height: 1.3,
                              ),
                            ),
                          ),
                          // Arrow container
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: gradient.first.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: gradient.first,
                              size: 18.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void navigateToEarlyDetection() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => FAQDetailView(
              title: viewModel.local!.earlyDetection,
              content: viewModel.local!.earlyDetectionContent,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void navigateToAIInfo() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => FAQDetailView(
              title: viewModel.local!.aiInfo,
              content: viewModel.local!.aiInfoContent,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void navigateToUserInfo() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => FAQDetailView(
              title: viewModel.local!.whoShouldUse,
              content: viewModel.local!.userInfoContent,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void navigateToComparisonWithDoctor() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => FAQDetailView(
              title: viewModel.local!.doesReplaceDoctor,
              content: viewModel.local!.comparisonContent,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void navigateToPrivacyInfo() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => FAQDetailView(
              title: viewModel.local!.isInfoSafe,
              content: viewModel.local!.privacyContent,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
