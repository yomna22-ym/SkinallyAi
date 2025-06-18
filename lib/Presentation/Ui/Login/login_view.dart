import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import '../../../Core/routes_manager/routes.dart';
import '../../../Data/DataSources/auth_remote_data_source.dart';
import '../../../Domain/Repositories/auth_repository_impl.dart';
import '../../../Domain/UseCases/login_use_case.dart';
import '../Widgets/custom_password_text_form_field.dart';
import '../Widgets/custom_text_form_field.dart';
import '../Widgets/language_switch.dart';
import 'Widgets/direct_platform_login.dart';
import 'login_navigator.dart';
import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  static const String routeName = 'Login';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseState<LoginView, LoginViewModel>
    implements LoginNavigator {

  @override
  LoginViewModel initViewModel() {
    final authRemoteDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
    final loginUseCase = LoginUseCase(repository: authRepository);

    return LoginViewModel(loginUseCase: loginUseCase);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.checkAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, value, child) => Scaffold(
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: viewModel.changeTheme,
                    overlayColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                    child: Image.asset(
                      viewModel.themeProvider!.isDark()
                          ? "Assets/Images/logo.png"
                          : "Assets/Images/logo.png",
                      height: 200,
                    ),
                  ),

                  // Error Message Display
                  if (viewModel.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Input Form
                  Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        // Email Text From Field
                        CustomTextFormField(
                          controller: viewModel.emailController,
                          inputType: TextInputType.emailAddress,
                          label: viewModel.local!.email,
                          validator: viewModel.emailValidation,
                          icon: EvaIcons.email,
                        ),
                        const SizedBox(height: 20),
                        // Password Text From Field
                        CustomPasswordTextFormField(
                          controller: viewModel.passwordController,
                          inputType: TextInputType.visiblePassword,
                          label: viewModel.local!.password,
                          validator: viewModel.passwordValidation,
                          icon: EvaIcons.lock,
                        ),
                        const SizedBox(height: 10),
                        // Forget Password Text Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: viewModel.goToForgetPasswordScreen,
                              child: Text(
                                viewModel.local!.forgetPassword,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                  color: viewModel.themeProvider!.isDark()
                                      ? MyTheme.offWhite
                                      : MyTheme.lightBlue,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Login Button
                        ElevatedButton(
                          onPressed: viewModel.isLoading ? null : viewModel.login,
                          child: viewModel.isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(viewModel.local!.login),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Create Account Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              viewModel.local!.doNotHaveAccount,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                color: viewModel.themeProvider!.isDark()
                                    ? MyTheme.offWhite
                                    : MyTheme.darkBlue,
                              ),
                            ),
                            TextButton(
                              onPressed: viewModel.goToRegistrationScreen,
                              child: Text(
                                viewModel.local!.createAccount,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: MyTheme.lightBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // or divider
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      const Expanded(child: Divider(thickness: 2)),
                      const SizedBox(width: 15),
                      Text(
                        viewModel.local!.or,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(width: 15),
                      const Expanded(child: Divider(thickness: 2)),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DirectPlatformLogin(
                    darkImage: "Assets/SVG/google_Dark.svg",
                    lightImage: "Assets/SVG/google_Dark.svg",
                    title: viewModel.local!.googleLogin,
                    //login: viewModel.loginWithGoogle,
                    loading: viewModel.googleLogin,
                  ),
                  const SizedBox(height: 20),
                  const LanguageSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  goToRegistrationScreen() {
    Navigator.pushReplacementNamed(context, Routes.registerRoute);
  }

  @override
  goToHomeScreen() {
    Navigator.pushReplacementNamed(context, Routes.homeRoute);
  }

  @override
  goToForgetPasswordScreen() {
    Navigator.pushNamed(context, Routes.forgetPasswordRoute);
  }

}
