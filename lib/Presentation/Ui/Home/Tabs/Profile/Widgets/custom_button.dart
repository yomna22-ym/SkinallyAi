import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

import '../../../../../../Core/Theme/theme.dart';
import '../../../../../Models/button.dart';

class CustomButton extends StatelessWidget {
  Button button;
  CustomButton({required this.button, super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => button.onClickListener(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: button.color,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                button.icon,
                size: 25.w,
                color: MyTheme.white,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              button.title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 16.sp),
            ),
            const Expanded(child: SizedBox()),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.w,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
