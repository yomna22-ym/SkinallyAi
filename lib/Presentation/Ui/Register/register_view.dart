import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:skinally_aii/Presentation/Ui/Register/register_navigator.dart';
import 'package:skinally_aii/Presentation/Ui/Register/register_view_model.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import '../../../Core/routes_manager/routes.dart';
import '../../../Data/DataSources/auth_remote_data_source.dart';
import '../../../Domain/Repositories/auth_repository_impl.dart';
import '../../../Domain/UseCases/login_use_case.dart';
import '../../../Domain/UseCases/register_use_case.dart';
import '../Widgets/custom_password_text_form_field.dart';
import '../Widgets/custom_text_form_field.dart';
import '../Widgets/language_switch.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = 'Register';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends BaseState<RegisterView, RegisterViewModel>
    implements RegisterNavigator {

  @override
  RegisterViewModel initViewModel() {
    final authRemoteDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
    final registerUseCase = RegisterUseCase(repository: authRepository);
    final loginUseCase = LoginUseCase(repository: authRepository);

    return RegisterViewModel(
      registerUseCase: registerUseCase,
      loginUseCase: loginUseCase,
    );
  }

  @override
  void goToHomeScreen() {
    Navigator.pushReplacementNamed(context, Routes.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      builder: (context, child) => Consumer<RegisterViewModel>(
        builder: (context, value, child) => Scaffold(
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        viewModel.themeProvider!.isDark()
                            ? "Assets/Images/logo.png"
                            : "Assets/Images/logo.png",
                        height: 200,
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

                      // Form Fields
                      Form(
                        key: viewModel.formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              label: viewModel.local!.name,
                              controller: viewModel.nameController,
                              validator: viewModel.nameValidation,
                              inputType: TextInputType.name,
                              icon: EvaIcons.file,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: viewModel.local!.email,
                              controller: viewModel.emailController,
                              inputType: TextInputType.emailAddress,
                              validator: viewModel.emailValidation,
                              icon: EvaIcons.email,
                            ),
                            const SizedBox(height: 20),
                            CustomPasswordTextFormField(
                              label: viewModel.local!.password,
                              controller: viewModel.passwordController,
                              inputType: TextInputType.visiblePassword,
                              validator: viewModel.passwordValidation,
                              icon: EvaIcons.lock,
                            ),
                            const SizedBox(height: 20),
                            CustomPasswordTextFormField(
                              label: viewModel.local!.passwordConfirmation,
                              controller: viewModel.passwordConfirmationController,
                              inputType: TextInputType.visiblePassword,
                              validator: viewModel.passwordConfirmationValidation,
                              icon: EvaIcons.lock,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: 'Phone Number',
                              controller: viewModel.phoneController,
                              validator: viewModel.phoneValidation,
                              inputType: TextInputType.phone,
                              icon: EvaIcons.phone,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: 'Address',
                              controller: viewModel.addressController,
                              validator: viewModel.addressValidation,
                              inputType: TextInputType.streetAddress,
                              icon: EvaIcons.home,
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: viewModel.isLoading ? null : viewModel.register,
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
                                    child: Text(
                                      viewModel.local!.createNewAccount,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModel.local!.alreadyHaveAccount,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              color: viewModel.themeProvider!.isDark()
                                  ? MyTheme.offWhite
                                  : MyTheme.darkBlue,
                            ),
                          ),
                          TextButton(
                            onPressed: viewModel.goToLoginScreen,
                            child: Text(
                              viewModel.local!.login,
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: MyTheme.lightBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const LanguageSwitch(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToLoginScreen() {
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  @override
  void goToLoginScreenWithData({required String email, required String password}) {
    Navigator.pushReplacementNamed(
      context,
      Routes.loginRoute,
      arguments: {'email': email, 'password': password},
    );
  }

}
