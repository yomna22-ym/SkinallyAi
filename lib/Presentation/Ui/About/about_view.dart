import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Base/base_view_model.dart';
import 'Widgets/enhanced_list_points.dart';
import 'Widgets/enhanced_text_card.dart';

class AboutView extends StatefulWidget {
  static const String routeName = "About";

  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends BaseState<AboutView, BaseViewModel> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.local!.aboutUs),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor.withOpacity(0.02),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 80), // Space for transparent AppBar

              // App Title with enhanced styling
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.health_and_safety,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "SkinallyAI",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                viewModel.local!.aboutUsMessage1,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Enhanced image container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Lottie.asset(
                    "Assets/Animations/about3.json",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Text(
                viewModel.local!.aboutUsMessage2,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              EnhancedTextCard(content: viewModel.local!.mainFeatures),

              const SizedBox(height: 30),

              EnhancedListPoints(content: viewModel.local!.aboutUsMessage3),
              EnhancedListPoints(content: viewModel.local!.aboutUsMessage4),

              // Enhanced Lottie container
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                child: Lottie.asset(
                  "Assets/Animations/about4.json",
                  fit: BoxFit.contain,
                ),
              ),

              EnhancedListPoints(content: viewModel.local!.aboutUsMessage5),
              EnhancedListPoints(content: viewModel.local!.aboutUsMessage6),
              EnhancedListPoints(content: viewModel.local!.aboutUsMessage7),

              const SizedBox(height: 10),

              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                ),
              child: Lottie.asset(
                  "Assets/Animations/about.json",
                  fit: BoxFit.contain,
               ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  viewModel.local!.aboutUsMessage8,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              EnhancedTextCard(content: viewModel.local!.appVersion),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BaseViewModel initViewModel() {
    return BaseViewModel();
  }
}

