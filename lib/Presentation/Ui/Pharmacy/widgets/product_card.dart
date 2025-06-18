import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Theme/theme.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;
  final bool isGridView;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    this.isGridView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? MyTheme.darkBlue : MyTheme.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isGridView ? _buildGridCard(context, isDark) : _buildListCard(context, isDark),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: _buildProductImage(),
            ),
          ),
        ),

        // Product Info - FIXED: Removed price, added purchase button
        Container(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Name
              Text(
                product['name'] ?? 'Unknown Product',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? MyTheme.offWhite : MyTheme.darkBlue,
                  fontSize: 14.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4.h),

              // Product Type/Category
              Text(
                product['productTypeName'] ?? product['category'] ?? 'Unknown',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? MyTheme.offWhite.withOpacity(0.7)
                      : MyTheme.darkBlue.withOpacity(0.6),
                  fontSize: 12.sp,
                ),
              ),

              SizedBox(height: 8.h),

              // Buy Button - FIXED: Changed from price to purchase button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.blue,
                    foregroundColor: MyTheme.offWhite,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 16.w,
                  ),
                  label: Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context, bool isDark) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 96.w,
            height: 96.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildProductImage(),
            ),
          ),

          SizedBox(width: 12.w),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Name and Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Unknown Product',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? MyTheme.offWhite : MyTheme.darkBlue,
                        fontSize: 16.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      product['productTypeName'] ?? product['category'] ?? 'Unknown',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? MyTheme.offWhite.withOpacity(0.7)
                            : MyTheme.darkBlue.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),

                // Buy Button - FIXED: Changed from price to purchase button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.blue,
                      foregroundColor: MyTheme.offWhite,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 16.w,
                    ),
                    label: Text(
                      'Buy on Amazon',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    // FIXED: Properly handle image URLs
    String imageUrl = product['image'] ?? product['imageUrl'] ?? '';

    // Fix localhost URLs
    if (imageUrl.contains('localhost:7143')) {
      imageUrl = imageUrl.replaceAll('https://localhost:7143', 'https://skinally.runasp.net')
          .replaceAll('http://localhost:7143', 'https://skinally.runasp.net');
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: isGridView ? 40.w : 32.w,
                color: Colors.grey.shade400,
              ),
              if (isGridView) ...[
                SizedBox(height: 4.h),
                Text(
                  'No Image',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey.shade100,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MyTheme.blue),
              strokeWidth: 2.0,
            ),
          ),
        );
      },
    );
  }
}