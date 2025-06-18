import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../Core/Providers/theme_provider.dart';
import '../../../Core/Theme/theme.dart';
import '../Home/home_view.dart';
import '../Intro/intro_view.dart';
import '../Login/login_view.dart';

class SplashScreen extends StatelessWidget {

  final bool firstTime;
  final bool loggedIn;

  const SplashScreen({
    required this.firstTime,
    required this.loggedIn,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    Widget nextScreen;

    if (firstTime) {
      nextScreen = const IntroView();
    } else if (loggedIn) {
      nextScreen = const HomeView();
    } else {
      nextScreen = const LoginView();
    }

    return AnimatedSplashScreen(
      splash: Center(
        child: SizedBox(
          height: 300.h,
          child: Image.asset(
            "Assets/Images/animated_logo.gif",
            fit: BoxFit.cover,
          ),
        ),
      ),
      nextScreen: nextScreen,
      duration: 2000,
      backgroundColor: themeProvider.isDark()
          ? MyTheme.darkBlue
          : MyTheme.whiteBlue,
      splashIconSize: double.infinity,
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}

