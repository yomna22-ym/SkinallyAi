import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import '../../../Core/routes_manager/routes.dart';
import '../Login/login_view.dart';
import '../Widgets/language_switch.dart';
import '../Widgets/theme_switch.dart';
import 'intro_navigator.dart';
import 'intro_view_model.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends BaseState<IntroView, IntroViewModel>
    implements IntroNavigator {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          // pick Your Language
          PageViewModel(
            decoration: PageDecoration(
              titleTextStyle: Theme.of(context).textTheme.displayLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp),
              bodyTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              imageFlex: 2,
              titlePadding: const EdgeInsets.all(20),
              bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
              imagePadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            title: viewModel.local!.yourLanguage,
            // title: "Welcome",
            bodyWidget: const LanguageSwitch(),
            image: Lottie.asset("Assets/Animations/language.json"),
          ),
          // pick Your theme
          PageViewModel(
            decoration: PageDecoration(
              titleTextStyle: Theme.of(context).textTheme.displayLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
              bodyTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              imageFlex: 2,
              titlePadding: const EdgeInsets.all(20),
              bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
              imagePadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            title: viewModel.local!.makeItYourOwn,
            // title: "Welcome",
            bodyWidget: const ThemeSwitch(),
            image: Lottie.asset("Assets/Animations/themes.json"),
          ),
          // Welcome Message
          PageViewModel(
            decoration: PageDecoration(
              titleTextStyle: Theme.of(context).textTheme.displayLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
              bodyTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              imageFlex: 2,
              titlePadding: const EdgeInsets.all(20),
              bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
              imagePadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            title: viewModel.local!.welcome,
            // title: "Welcome",
            body: viewModel.local!.welcomeToSkin,
            image: Lottie.asset("Assets/Animations/hello.json"),
          ),
          PageViewModel(
            decoration: PageDecoration(
              titleTextStyle: Theme.of(context).textTheme.displayLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
              bodyTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              imageFlex: 2,
              titlePadding: const EdgeInsets.all(20),
              bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
              imagePadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            title: viewModel.local!.cancerTypes,
            // title: "Welcome",
            body: viewModel.local!.letUsHelpYou,
            image: Lottie.asset("Assets/Animations/JnEaKl20sp.json"),
          ),
          PageViewModel(
            decoration: PageDecoration(
              titleTextStyle: Theme.of(context).textTheme.displayLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
              bodyTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              imageFlex: 2,
              titlePadding: const EdgeInsets.all(20),
              bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
              imagePadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            title: viewModel.local!.youAreNotAlone,
            // title: "Welcome",
            body: viewModel.local!.chatWithAi,
            image: Lottie.asset("Assets/Animations/aiChat.json"),
          ),
          // Who Are You
          PageViewModel(
            decoration: PageDecoration(
              titleTextStyle: Theme.of(context).textTheme.displayLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
              bodyTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              imageFlex: 2,
              titlePadding: const EdgeInsets.all(20),
              bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
              imagePadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            title: viewModel.local!.whoAreYou,
            // title: "Welcome",
            body: viewModel.local!.letUsKnowWhoYouAre,
            image: Lottie.asset("Assets/Animations/login.json"),
          ),
        ],
        done: Text(viewModel.local!.finish),
        next: Text(viewModel.local!.next),
        back: Text(viewModel.local!.back),
        backStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
          foregroundColor: WidgetStateProperty.all(
            Theme.of(context).primaryColor,
          ),
        ),
        nextStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
          foregroundColor: WidgetStateProperty.all(
            Theme.of(context).primaryColor,
          ),
        ),
        doneStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
          foregroundColor: WidgetStateProperty.all(
            Theme.of(context).primaryColor,
          ),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: MyTheme.lightBlue,
          color: Theme.of(context).primaryColor,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        showBackButton: true,
        onDone: viewModel.onDonePress,
      ),
    );
  }

  @override
  IntroViewModel initViewModel() {
    return IntroViewModel();
  }

  @override
  goToLoginScreen() {
    Navigator.pushReplacementNamed(
      context,
      Routes.loginRoute,
      arguments: context,
    );
  }
}
