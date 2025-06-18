import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Categories/widgets/interactive_3d_card.dart';
import '../../../../../Core/Base/base_state.dart';
import '../../../../../Core/Theme/theme.dart';
import 'categories_view_model.dart';
import 'Category Details/category_details.dart';
import 'widgets/category_model.dart';
import 'category_navigator.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState
    extends BaseState<CategoriesView, CategoriesViewModel>
    implements CategoryNavigator {
  @override
  CategoriesViewModel initViewModel() {
    return CategoriesViewModel();
  }

  @override
  void initState() {
    super.initState();
    viewModel.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider<CategoriesViewModel>(
          create: (_) => viewModel,
          child: Consumer<CategoriesViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(MyTheme.blue),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Loading Categories...',
                        style: TextStyle(
                          color: MyTheme.lightBlue,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (vm.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                      SizedBox(height: 16.h),
                      Text(
                        vm.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => vm.loadCategories(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (vm.categories.isEmpty) {
                return Center(
                  child: Text(
                    'No categories available',
                    style: TextStyle(color: MyTheme.lightBlue, fontSize: 16.sp),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => vm.loadCategories(),
                color: MyTheme.blue,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  itemCount: vm.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: _getAspectRatio(context),
                  ),
                  itemBuilder: (context, index) {
                    final category = vm.categories[index];
                    return _buildCategoryCard(context, category, index);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    return 2;
  }

  double _getAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) return 0.85;
    return 0.8;
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryModel category,
    int index,
  ) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      child: Interactive3DCard(
        child: GestureDetector(
          onTap: () => _navigateToDetails(category),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: MyTheme.blue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
                side: BorderSide(
                  color: MyTheme.blue.withOpacity(0.2),
                  width: 1.w,
                ),
              ),
              elevation: 0,
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                        child: Stack(
                          children: [
                            _buildImage(category),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: MyTheme.lightBlue,
                                fontSize: _getFontSize(context),
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (category.description != null) ...[
                            SizedBox(height: 4.h),
                            Flexible(
                              child: Text(
                                category.description!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10.sp,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
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

  Widget _buildImage(CategoryModel category) {
    if (kDebugMode) {
      print('Category: ${category.name}');
    }

    final imageUrl = _getLocalImagePath(category.name);

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          print('Failed to load local asset: $imageUrl, Error: $error');
        }
        return _buildFallbackImage(category.name);
      },
    );
  }

  Widget _buildFallbackImage(String categoryName) {
    return Container(
      color: MyTheme.blue.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 40.w,
            color: MyTheme.blue,
          ),
          SizedBox(height: 8.h),
          Text(
            categoryName,
            style: TextStyle(
              color: MyTheme.blue,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getLocalImagePath(String categoryName) {
    final Map<String, String> imageMap = {
      'melanoma': 'Assets/categories/melanoma.jpg',
      'melanocytic nevus': 'Assets/categories/melanocytic.jpg',
      'basal cell carcinoma': 'Assets/categories/basel cell.jpg',
      'dermatofibroma': 'Assets/categories/dermatofibroma.jpg',
      'actinic keratosis': 'Assets/categories/actinic keratosis.jpg',
      'benign keratosis': 'Assets/categories/bengin keratosis.jpg',
      'vascular': 'Assets/categories/vascular.jpg',
      'squamous cell carcinoma': 'Assets/categories/squamous cell.jpg',
    };

    final key = imageMap.keys.firstWhere(
          (k) => categoryName.toLowerCase().contains(k),
      orElse: () => '',
    );

    return imageMap[key] ?? 'Assets/Images/errorImage.png';
  }

  double _getFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) return 16.sp;
    return 14.sp;
  }

  void _navigateToDetails(CategoryModel category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                CategoryDetailsView(category: category),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void bookmarkCategory(int categoryId) {}

  @override
  void navigateToDetails(int categoryId) {}

  @override
  void navigateToSearch() {}

  @override
  void shareCategory(String categoryName) {}

  @override
  void showCategoryImages(List<String> images, int initialIndex) {}
}
