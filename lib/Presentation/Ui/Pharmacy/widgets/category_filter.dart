import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Theme/theme.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final EdgeInsets? padding;

  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50.h,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: _buildCategoryChip(context, category, isSelected, isDark),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String category,
    bool isSelected,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => onCategorySelected(category),
      borderRadius: BorderRadius.circular(25.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? MyTheme.blue
                  : (isDark ? MyTheme.darkBlue : MyTheme.offWhite),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color:
                isSelected
                    ? MyTheme.blue
                    : (isDark ? Colors.grey.shade600 : Colors.grey.shade300),
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: MyTheme.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color:
                          isDark
                              ? Colors.black.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Icon (optional)
            if (category != 'All') ...[
              Icon(
                _getCategoryIcon(category),
                size: 16.w,
                color:
                    isSelected
                        ? MyTheme.offWhite
                        : (isDark ? MyTheme.offWhite : MyTheme.darkBlue),
              ),
              SizedBox(width: 6.w),
            ],

            // Category Text
            Text(
              _formatCategoryName(category),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    isSelected
                        ? MyTheme.offWhite
                        : (isDark ? MyTheme.offWhite : MyTheme.darkBlue),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'medicine':
      case 'medicines':
        return Icons.medical_services;
      case 'vitamin':
      case 'vitamins':
        return Icons.medication;
      case 'supplement':
      case 'supplements':
        return Icons.medical_information;
      case 'skincare':
      case 'skin care':
        return Icons.face;
      case 'personal care':
      case 'personalcare':
        return Icons.spa;
      case 'baby':
      case 'baby care':
        return Icons.child_care;
      case 'health':
      case 'healthcare':
        return Icons.health_and_safety;
      case 'first aid':
      case 'firstaid':
        return Icons.local_hospital;
      case 'dental':
      case 'oral care':
        return Icons.clean_hands;
      case 'eye care':
      case 'eyecare':
        return Icons.remove_red_eye;
      default:
        return Icons.category;
    }
  }

  String _formatCategoryName(String category) {
    if (category == 'All') return 'All';

    // Capitalize first letter of each word
    return category
        .split(' ')
        .map(
          (word) =>
              word.isEmpty
                  ? word
                  : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
