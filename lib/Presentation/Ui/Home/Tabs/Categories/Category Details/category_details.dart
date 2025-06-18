import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../Core/Base/base_state.dart';
import '../../../../../../Core/Theme/theme.dart';
import '../widgets/category_model.dart';
import 'category_details_view_model.dart';
import '../category_navigator.dart';

class CategoryDetailsView extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailsView({super.key, required this.category});

  @override
  State<CategoryDetailsView> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState
    extends BaseState<CategoryDetailsView, CategoryDetailsViewModel>
    with TickerProviderStateMixin
    implements CategoryNavigator {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  CategoryDetailsViewModel initViewModel() {
    return CategoryDetailsViewModel();
  }

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    viewModel.loadCategoryDetails(widget.category.id);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Navigation methods implementation
  @override
  void showFullScreenImages(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => _FullScreenImageView(
              images: images,
              initialIndex: initialIndex,
              categoryName: widget.category.name,
            ),
      ),
    );
  }



  @override
  void navigateToDetails(int categoryId) {}

  @override
  void navigateToSearch() {}

  @override
  void bookmarkCategory(int categoryId) {}



  // Rename your existing method to match the interface
  @override
  void showCategoryImages(List<String> images, int initialIndex) {
    showFullScreenImages(images, initialIndex); // Reuse existing
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: ChangeNotifierProvider<CategoryDetailsViewModel>(
          create: (_) => viewModel,
          child: Consumer<CategoryDetailsViewModel>(
            builder: (context, vm, child) {
              return CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: REdgeInsets.all(16.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryInfo(),
                              _buildImageCarousel(),
                              _buildDescription(),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 95.h,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: MyTheme.lightBlue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        child: FlexibleSpaceBar(
          title: Text(
            widget.category.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: MyTheme.white,
              fontSize: 20.sp
            ),
          ),
          titlePadding: EdgeInsets.only(left: 60.w, bottom: 16.h),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 40.w, color: MyTheme.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
  void _showFullScreenImage(int index) {
    final images = viewModel.categoryImages.isNotEmpty
        ? viewModel.categoryImages
        : widget.category.imagesUrl;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenImageView(
          images: images,
          initialIndex: index,
          categoryName: widget.category.name,
        ),
      ),
    );
  }


  Widget _buildImageCarousel() {
    // Use category images from ViewModel or fallback to widget category images
    final images = viewModel.categoryImages.isNotEmpty
        ? viewModel.categoryImages
        : widget.category.imagesUrl;

    if (kDebugMode) {
      print('Building carousel with ${images.length} images: $images');
    }

    if (images.isEmpty) {
      return Container(
        height: 300.h,
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: MyTheme.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 60.w, color: MyTheme.blue),
              SizedBox(height: 16.h),
              Text(
                'No images available',
                style: TextStyle(
                  color: MyTheme.blue,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 300.h,
      margin: EdgeInsets.all(16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(index),
                  child: Hero(
                    tag: 'image_$index',
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildImage(images[index]),
                    ),
                  ),
                );
              },
            ),
            if (images.length > 1) _buildImageIndicators(images.length),
            _buildImageOverlay(images.length),
          ],
        ),
      ),
    );
  }
  Widget _buildImage(String imageUrl) {
    // Convert localhost to production URL if needed
    String finalImageUrl = imageUrl;
    if (imageUrl.contains('localhost:7143')) {
      finalImageUrl = imageUrl.replaceAll('https://localhost:7143', 'https://skinally.runasp.net');
    }

    if (kDebugMode) {
      print('Loading detail image: $finalImageUrl');
    }

    if (finalImageUrl.startsWith('http')) {
      return Image.network(
        finalImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[100],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(MyTheme.blue),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            print('Failed to load detail image: $finalImageUrl, Error: $error');
          }
          return _buildFallbackImage();
        },
      );
    } else {
      return Image.asset(
        finalImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
  }
  Widget _buildFallbackImage() {
    return Container(
      color: MyTheme.blue.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services_rounded, size: 60.w, color: MyTheme.blue),
          SizedBox(height: 16.h),
          Text(
            widget.category.name,
            style: TextStyle(
              color: MyTheme.blue,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageIndicators(int count) {
    return Positioned(
      bottom: 16.h,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: _currentImageIndex == index ? 24.w : 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color:
                  _currentImageIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageOverlay(int totalImages) {
    return Positioned(
      top: 16.h,
      right: 16.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library, color: Colors.white, size: 16.w),
            SizedBox(width: 4.w),
            Text(
              '${_currentImageIndex + 1}/$totalImages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: MyTheme.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.medical_information,
                  color: MyTheme.blue,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.lightBlue,
                      ),
                    ),
                    if (widget.category.title != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        widget.category.title!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    );
  }

  Widget _buildDescription() {
    if (widget.category.description == null) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: MyTheme.blue, size: 20.w),
              SizedBox(width: 8.w),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: MyTheme.lightBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            widget.category.description!,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }


  void _shareCategory() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: MyTheme.blue,
      ),
    );
  }


  void _bookmarkCategory() {
    // Implement bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category bookmarked!'),
        backgroundColor: MyTheme.blue,
      ),
    );
  }

  @override
  void shareCategory(String categoryName) {
  }
}

class _FullScreenImageView extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  final String categoryName;

  const _FullScreenImageView({
    required this.images,
    required this.initialIndex,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(categoryName),
        actions: [IconButton(icon: Icon(Icons.share), onPressed: () {})],
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                images[index],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.white, size: 50),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
