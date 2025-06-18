import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinally_aii/Presentation/Ui/Pharmacy/widgets/category_filter.dart';
import 'package:skinally_aii/Presentation/Ui/Pharmacy/widgets/pharmacy_search_bar.dart';
import 'package:skinally_aii/Presentation/Ui/Pharmacy/widgets/product_card.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import 'pharmacy_navigator.dart';
import 'pharmacy_view_model.dart';

class PharmacyView extends StatefulWidget {

  const PharmacyView({super.key});

  @override
  State<PharmacyView> createState() => _PharmacyViewState();
}

class _PharmacyViewState extends BaseState<PharmacyView, PharmacyViewModel>
    implements PharmacyNavigator {
  @override
  PharmacyViewModel initViewModel() => PharmacyViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<PharmacyViewModel>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: viewModel.themeProvider!.isDark()
              ? MyTheme.darkBlue
              : MyTheme.whiteBlue,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(95.h),
            child: Container(
              decoration: BoxDecoration(
                color: MyTheme.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: MyTheme.white),
                title: Text(
                  viewModel.local!.pharmacy,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: MyTheme.white,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      viewModel.isGridView ? Icons.list : Icons.grid_view,
                      color: MyTheme.white,
                    ),
                    onPressed: viewModel.toggleView,
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: viewModel.refreshProducts,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: PharmacySearchBar(
                              controller: viewModel.searchController,
                              onSearch: viewModel.searchProducts,
                              onClear: viewModel.clearSearch,
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                            child: CategoryFilter(
                              categories: viewModel.categories,
                              selectedCategory: viewModel.selectedCategory,
                              onCategorySelected: viewModel.selectCategory,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          if (viewModel.errorMessage != null)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12.r),
                                border:
                                Border.all(color: Colors.red.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red.shade700),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      viewModel.errorMessage!,
                                      style: TextStyle(
                                          color: Colors.red.shade700),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.red.shade700),
                                    onPressed: viewModel.clearError,
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 8.h),
                          viewModel.isLoading && viewModel.products.isEmpty
                              ? _buildLoadingWidget()
                              : viewModel.products.isEmpty
                              ? _buildEmptyWidget()
                              : SizedBox(
                            height: constraints.maxHeight - 250.h,
                            child: _buildProductsWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyTheme.blue),
        ),
        SizedBox(height: 16.h),
        Text(
          viewModel.local!.loading,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: viewModel.themeProvider!.isDark()
                ? MyTheme.offWhite
                : MyTheme.darkBlue,
          ),
        ),
      ],
    ),
  );

  Widget _buildEmptyWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inventory_2_outlined,
          size: 80.w,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 16.h),
        Text(
          viewModel.searchController.text.isNotEmpty
              ? viewModel.local!.noSearchResults
              : viewModel.local!.noProducts,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        if (viewModel.searchController.text.isNotEmpty) ...[
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: viewModel.clearSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.blue,
              foregroundColor: MyTheme.offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(viewModel.local!.clearSearch),
          ),
        ],
      ],
    ),
  );

  Widget _buildProductsWidget() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!viewModel.isLoading &&
            viewModel.hasMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          viewModel.loadMoreProducts();
        }
        return false;
      },
      child: viewModel.isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: viewModel.products.length + (viewModel.hasMore ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemBuilder: (context, index) {
          if (index == viewModel.products.length) {
            return _buildLoadingItem();
          }
          return ProductCard(
            product: viewModel.products[index],
            onTap: () => viewModel.selectProduct(viewModel.products[index]),
            isGridView: true,
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: viewModel.products.length + (viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.products.length) {
            return _buildLoadingItem();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: ProductCard(
              product: viewModel.products[index],
              onTap: () => viewModel.selectProduct(viewModel.products[index]),
              isGridView: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingItem() => Container(
    height: 60.h,
    margin: EdgeInsets.symmetric(vertical: 8.h),
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyTheme.blue),
      ),
    ),
  );

  @override
  void goToProductDetails(String productId) {
    Navigator.pushNamed(context, '/product-details', arguments: productId);
  }

  @override
  void showProductBottomSheet(dynamic product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductBottomSheet(product),
    );
  }

  Widget _buildProductBottomSheet(dynamic product) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: viewModel.themeProvider!.isDark()
            ? MyTheme.darkBlue
            : MyTheme.offWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      product['image'] ?? '',
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200.h,
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50.w,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    product['name'] ?? 'Unknown Product',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: viewModel.themeProvider!.isDark()
                          ? MyTheme.offWhite
                          : MyTheme.darkBlue,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // FIXED: Show product type instead of price
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: MyTheme.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: MyTheme.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      product['productTypeName'] ?? product['category'] ?? 'Unknown Type',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MyTheme.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'This is a high-quality ${product['productTypeName']?.toString().toLowerCase() ?? 'skincare product'} designed to meet your skincare needs. Click the button below to view and purchase this product from Amazon.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: viewModel.themeProvider!.isDark()
                          ? MyTheme.offWhite.withOpacity(0.8)
                          : MyTheme.darkBlue.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            viewModel.openPurchaseUrl(product);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.blue,
                            foregroundColor: MyTheme.offWhite,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 20.w,
                          ),
                          label: Text(
                            'Buy on Amazon',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}