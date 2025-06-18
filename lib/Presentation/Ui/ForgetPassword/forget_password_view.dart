import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Base/base_state.dart';
import '../Widgets/custom_text_form_field.dart';
import 'forget_password_view_model.dart';

class ForgetPasswordView extends StatefulWidget {
  static const String routeName = "ForgetPassword";

  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState
    extends BaseState<ForgetPasswordView, ForgetPasswordViewModel> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.local!.forgetPassword)),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            children: [
              Lottie.asset(
                viewModel.themeProvider!.isDark()
                    ? "Assets/Animations/forgetMail.json"
                    : "Assets/Animations/forgetPass.json",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.h),
              Form(
                key: viewModel.formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: viewModel.local!.email,
                      controller: viewModel.emailController,
                      inputType: TextInputType.emailAddress,
                      validator: viewModel.emailValidation,
                      icon: HeroIcons.envelope,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.all(15.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(viewModel.local!.sendMail)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ForgetPasswordViewModel initViewModel() {
    return ForgetPasswordViewModel();
  }
}
