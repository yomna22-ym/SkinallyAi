import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTheme {
  static const Color offWhite = Color(0xFFF3F3E0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF85CC36);
  static const Color yellow = Color(0xFFF9A541);
  static const Color red = Color(0xFFF73645);
  static const Color lightBlue = Color(0xFF133E87);
  static const Color greyBlue = Color(0xFF608BC1);
  static const Color darkBlue = Color(0xFF01102B);
  static const Color whiteBlue = Color(0xFFCBDCEB);
  static const Color blue = Color(0xFF1C0998);

  static ThemeData lightTheme = ThemeData(
    // the screen background
    scaffoldBackgroundColor: whiteBlue,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightBlue,
      foregroundColor: white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: lightBlue,
      enableFeedback: true,
      selectedItemColor: white,
      unselectedItemColor: blue,
      showSelectedLabels: false,
      showUnselectedLabels: true,
      unselectedLabelStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

    // the elevated button style in thee screen
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(offWhite),
        backgroundColor: WidgetStateProperty.all(lightBlue),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: offWhite,
          ),
        ),
      ),
    ),

    // all text theme in the app
    textTheme: TextTheme(
      displaySmall: TextStyle(fontSize: 12.sp, color: lightBlue),
      displayMedium: TextStyle(fontSize: 16.sp, color: lightBlue),
      displayLarge: TextStyle(fontSize: 20.sp, color: lightBlue),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: lightBlue),
    // app bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: lightBlue,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: lightBlue),
      actionsIconTheme: const IconThemeData(color: lightBlue),
    ),
    primaryColor: lightBlue,
    dialogBackgroundColor: MyTheme.offWhite,
    dividerColor: lightBlue,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    // the screen background
    scaffoldBackgroundColor: darkBlue,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: blue,
      foregroundColor: white,
    ),

    // the elevated button style in thee screen
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(offWhite),
        backgroundColor: WidgetStateProperty.all(lightBlue),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: offWhite,
          ),
        ),
      ),
    ),

    // all text theme in the app
    textTheme: TextTheme(
      displaySmall: TextStyle(fontSize: 12.sp, color: offWhite),
      displayMedium: TextStyle(fontSize: 16.sp, color: offWhite),
      displayLarge: TextStyle(fontSize: 20.sp, color: offWhite),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: offWhite),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: blue,
      enableFeedback: true,
      selectedItemColor: white,
      unselectedItemColor: greyBlue,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),

    // app bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: offWhite,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: offWhite),
      actionsIconTheme: const IconThemeData(color: offWhite),
    ),

    primaryColor: offWhite,
    dialogBackgroundColor: blue,
    dividerColor: offWhite,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
  );
}