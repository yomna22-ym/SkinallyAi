import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

import '../../../../../../Core/Theme/theme.dart';
import '../../../../../Models/services_card.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceCard service;

  const ServiceCardWidget({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Remove screenWidth calculation as we'll use ScreenUtil

    return GestureDetector(
      onTap: service.onClickListener,
      child: Row(
        children: [
          // Circular image on the left
          Container(
            // Use .w and .h for size based on design
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.r, // Use .r for blur radius
                  offset: Offset(0, 2.h), // Use .h for vertical offset
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                service.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40.w, // Use .w for icon size
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w), // Use .w for horizontal space
          // Content container with title, subtitle and arrow
          Expanded(
            child: Container(
              // Use .h for height based on design
              height: 100.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12.r), // Use .r for border radius
              ),
              child: Stack(
                children: [
                  // Text content
                  Padding(
                    padding: EdgeInsets.all(16.w), // Use .w for padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? MyTheme.white : MyTheme.lightBlue,
                            fontSize: 16.sp, // Use .sp for font size
                          ),
                        ),
                        SizedBox(height: 3.h), // Use .h for vertical space
                        Text(
                          service.subtitle,
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            fontSize: 12.sp, // Use .sp for font size
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Arrow button on the right
                  Positioned(
                    right: 8.w, // Use .w for horizontal position
                    top: 60.h, // Use .h for vertical position (may need adjustment based on desired alignment)
                    bottom: 0, // Keep bottom 0 to align with the bottom of the parent
                    child: Center(
                      child: Container(
                        // Use .w and .h for button size
                        width: 35.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? MyTheme.darkBlue : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2.r, // Use .r for blur radius
                              offset: Offset(0, 1.h), // Use .h for vertical offset
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.w, // Use .w for icon size
                          color: MyTheme.lightBlue,
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
  }
}

