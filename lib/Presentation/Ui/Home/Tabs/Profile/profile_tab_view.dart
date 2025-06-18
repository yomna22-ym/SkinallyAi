import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Profile/profile_tab_navigator.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Profile/profile_tab_view_model.dart';
import '../../../../../Core/Base/base_state.dart';
import '../../../../../Core/Theme/theme.dart';
import '../../../../../Core/routes_manager/routes.dart';
import '../../../EditProfile/edit_profile_view.dart';
import '../../../ResetPassword/reset_password_view.dart';
import '../../../Widgets/language_switch.dart';
import '../../../Widgets/theme_switch.dart';
import 'Widgets/custom_button.dart';
import 'Widgets/user_profile_data_widget.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({super.key});

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState
    extends BaseState<ProfileTabView, ProfileTabViewModel>
    implements ProfileTabNavigator {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    viewModel.setButtonsData();

    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<ProfileTabViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              UserProfileDataWidget(
                buttonTitle: '',
                buttonAction: () {},
                isEn: viewModel.localProvider!.isEn(),
                profileImageWidget: Icon(
                  Icons.person,
                  size: 50.sp,
                  color: MyTheme.lightBlue,
                ),
                userName: viewModel.userName,
                userEmail: viewModel.userEmail,
                isLoading: viewModel.isLoading,
              ),
              SizedBox(height: 30.h),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            viewModel.local!.theme,
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                fontWeight: FontWeight.bold, fontSize: 24.sp),
                          ),
                          const ThemeSwitch(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            viewModel.local!.language,
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                fontWeight: FontWeight.bold, fontSize: 24.sp),
                          ),
                          const LanguageSwitch(),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ...viewModel.buttonsData.map((button) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: CustomButton(button: button),
                        )).toList(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  ProfileTabViewModel initViewModel() {
    return ProfileTabViewModel();
  }

  @override
  void goToEditProfileScreen() {
    Navigator.pushNamed(context, EditProfileView.routeName);
  }

  @override
  void goToHistoryScreen() {
    Navigator.pushNamed(context, Routes.historyRoute);
  }

  @override
  void goToAboutUsScreen() {
    Navigator.pushNamed(context, Routes.aboutRoute);
  }

  @override
  void goToLoginScreen() {
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  @override
  void goToResetPasswordScreen() {
    Navigator.pushNamed(context, Routes.forgetPasswordRoute);
  }

  @override
  void goToFAQView() {
    Navigator.pushNamed(context, Routes.faqRoute);
  }
}
