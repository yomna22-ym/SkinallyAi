import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../Core/Theme/theme.dart';

class UserProfileDataWidget extends StatelessWidget {
  final bool isEn;
  final String buttonTitle;
  final Function buttonAction;
  final Widget? profileImageWidget;
  final String userName;
  final String userEmail;
  final bool isLoading;

  const UserProfileDataWidget({
    required this.isEn,
    required this.buttonTitle,
    required this.buttonAction,
    required this.profileImageWidget,
    required this.userName,
    required this.userEmail,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: MyTheme.lightBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: isEn ? Radius.circular(80.r) : const Radius.circular(0),
          bottomRight: isEn ? const Radius.circular(0) : Radius.circular(80.r),
        ),
      ),
      child: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: MyTheme.offWhite,
          strokeWidth: 2.w,
        ),
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0, 4.h),
                      blurRadius: 10.r,
                    ),
                  ],
                  color: MyTheme.offWhite,
                ),
                padding: EdgeInsets.all(15.w),
                child: profileImageWidget ??
                    Center(
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: MyTheme.lightBlue,
                      ),
                    ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Text(
                  userName,
                  style: TextStyle(
                    color: MyTheme.offWhite,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h,),
                Text(
                  userEmail,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: MyTheme.offWhite,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (buttonTitle.isNotEmpty)
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => buttonAction(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.offWhite,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                        ),
                        child: Text(
                          buttonTitle,
                          style: TextStyle(
                            color: MyTheme.lightBlue,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
