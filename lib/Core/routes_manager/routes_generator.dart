import 'dart:io';
import 'package:flutter/material.dart';
import 'package:skinally_aii/Core/routes_manager/routes.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Categories/Category%20Details/category_details.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Categories/categories_view.dart';
import 'package:skinally_aii/Presentation/Ui/Pharmacy/pharmacy_view.dart';
import '../../Presentation/Ui/About/about_view.dart';
import '../../Presentation/Ui/AiAssistant/ai_view.dart';
import '../../Presentation/Ui/BlogNews/blog_news_view.dart';
import '../../Presentation/Ui/ChatPromp/chat_view.dart';
import '../../Presentation/Ui/EditProfile/edit_profile_view.dart';
import '../../Presentation/Ui/FAQ/FAQ Details/faq_screen.dart';
import '../../Presentation/Ui/FAQ/faq_view.dart';
import '../../Presentation/Ui/ForgetPassword/forget_password_view.dart';
import '../../Presentation/Ui/History/history_view.dart';
import '../../Presentation/Ui/Home/Tabs/Upload/upload_tab_view.dart';
import '../../Presentation/Ui/Home/home_view.dart';
import '../../Presentation/Ui/Intro/intro_view.dart';
import '../../Presentation/Ui/Login/login_view.dart';
import '../../Presentation/Ui/Register/register_view.dart';
import '../../Presentation/Ui/ResetPassword/reset_password_view.dart';
import '../../Presentation/Ui/Splash/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        final args = settings.arguments as Map<String, bool>;
        return MaterialPageRoute(
          builder: (_) => SplashScreen(
            firstTime: args['firstTime'] ?? true,
            loggedIn: args['loggedIn'] ?? false,
          ),
        );

      case Routes.introRoute:
        return MaterialPageRoute(builder: (_) => const IntroView());

      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());

      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterView());

      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordView());

      case Routes.editProfileRoute:
        return MaterialPageRoute(builder: (_) => const EditProfileView());

      case Routes.historyRoute:
        return MaterialPageRoute(builder: (_) => const HistoryView());

      case Routes.aboutRoute:
        return MaterialPageRoute(builder: (_) => const AboutView());

      case Routes.resetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());

      case Routes.blogNewsRoute:
        return MaterialPageRoute(builder: (_) => const BlogNewsView());


      case Routes.faqRoute:
        return MaterialPageRoute(builder: (_) => const FAQView());

      case Routes.categoryViewRoute:
        return MaterialPageRoute(builder: (_) => const CategoriesView());

     // case Routes.categoryDetailsViewRoute:
        //return MaterialPageRoute(builder: (_) => const CategoryDetailsView(category: category));

      case Routes.faqDetailsRoute:
        return MaterialPageRoute(builder: (_) => const FAQDetailView(title: '', content: '',));

      case Routes.aiRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AiView(
            diagnosis: args?['diagnosis'],
            userName: args?['userName'] ?? 'User',
          ),
        );

      case Routes.uploadTabRoute:
        return MaterialPageRoute(
          builder: (_) => UploadTabView(file: settings.arguments as File),
        );

      case Routes.pharmacyRoute:
        return MaterialPageRoute(builder: (_) => PharmacyView());

      case Routes.chatRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatView(
            userName: args['userName'],
            userAge: args['userAge'],
            skinType: args['skinType'],
            bodyArea: args['bodyArea'],
            diagnosis: args['diagnosis'],
            gender: args['gender'],
          ),
        );



      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('No Route Found'),
        ),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}

