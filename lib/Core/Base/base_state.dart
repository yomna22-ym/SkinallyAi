import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Presentation/Ui/Search/search_view.dart';
import '../../Presentation/Ui/Widgets/bottom_sheet_image_picker.dart';
import '../Providers/local_provider.dart';
import '../Providers/theme_provider.dart';
import '../Theme/theme.dart';
import '../Utils/dialog_utils.dart';
import 'base_navigator.dart';
import 'base_view_model.dart';

abstract class BaseState<T extends StatefulWidget, VM extends BaseViewModel>
    extends State<T>
    implements BaseNavigator {
  late VM viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = initViewModel();
    viewModel.navigator = this;
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.navigator = null;
    viewModel.themeProvider = null;
    viewModel.localProvider = null;
  }

  VM initViewModel();

  @override
  Widget build(BuildContext context) {
    viewModel.themeProvider = Provider.of<ThemeProvider>(context);
    viewModel.localProvider = Provider.of<LocalProvider>(context);
    viewModel.local = AppLocalizations.of(context)!;
    viewModel.mediaQuery = MediaQuery
        .of(context)
        .size;
    return const SizedBox();
  }


  @override
  goBack() {
    Navigator.pop(context);
  }

  @override
  showFailMessage({
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  }) {
    MyDialogUtils.showFailMessage(
      context: context,
      message: message,
      negativeActionTitle: negativeActionTitle,
      posActionTitle: posActionTitle,
      posAction: posAction,
      negativeAction: negativeAction,
    );
  }

  @override
  showLoading({required String message}) {
    MyDialogUtils.showLoadingDialog(context: context, message: message);
  }

  @override
  showQuestionMessage({
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  }) {
    MyDialogUtils.showQuestionMessage(
      context: context,
      message: message,
      negativeActionTitle: negativeActionTitle,
      posActionTitle: posActionTitle,
      posAction: posAction,
      negativeAction: negativeAction,
    );
  }

  @override
  showSuccessMessage({
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  }) {
    MyDialogUtils.showSuccessMessage(
      context: context,
      message: message,
      negativeActionTitle: negativeActionTitle,
      posActionTitle: posActionTitle,
      posAction: posAction,
      negativeAction: negativeAction,
    );
  }

  @override
  showSuccessNotification({required String message}) {
    ElegantNotification(
      icon: Icon(EvaIcons.checkmark, color: MyTheme.offWhite, size: 20.w),
      description: Text(
        message,
        style: Theme
            .of(context)
            .textTheme
            .displaySmall!
            .copyWith(
          color: MyTheme.offWhite,
          fontSize: 14.sp,
        ),
      ),
      background: Colors.green,
      position: Alignment.bottomCenter,
      animation: AnimationType.fromBottom,
      displayCloseButton: false,
      progressIndicatorBackground: Colors.transparent,
      showProgressIndicator: false,
      width: viewModel.mediaQuery?.width ?? MediaQuery
          .of(context)
          .size
          .width,
      borderRadius: BorderRadius.circular(15.r),
      height: 50.h,
    ).show(context);
  }

  @override
  showErrorNotification({required String message}) {
    ElegantNotification(
      icon: Icon(EvaIcons.close, color: MyTheme.offWhite, size: 20.w),
      description: Text(
        message,
        style: Theme
            .of(context)
            .textTheme
            .displaySmall!
            .copyWith(
          color: MyTheme.offWhite,
          fontSize: 14.sp,
        ),
      ),
      background: Colors.red,
      position: Alignment.bottomCenter,
      animation: AnimationType.fromBottom,
      displayCloseButton: false,
      progressIndicatorBackground: Colors.transparent,
      showProgressIndicator: false,
      width: viewModel.mediaQuery?.width ?? MediaQuery
          .of(context)
          .size
          .width,
      borderRadius: BorderRadius.circular(15.r),
      height: 50.h,
    ).show(context);
  }

  @override
  showCustomNotification({
    required IconData iconData,
    required String message,
    required Color background,
    required double height,
  }) {
    ElegantNotification(
      icon: Icon(iconData, color: MyTheme.offWhite, size: 20.w),
      description: Text(
        message,
        style: Theme
            .of(context)
            .textTheme
            .displaySmall!
            .copyWith(
          color: MyTheme.offWhite,
          fontSize: 14.sp,
        ),
      ),
      background: background,
      position: Alignment.bottomCenter,
      animation: AnimationType.fromBottom,
      displayCloseButton: false,
      progressIndicatorBackground: Colors.transparent,
      showProgressIndicator: false,
      width: viewModel.mediaQuery?.width ?? MediaQuery
          .of(context)
          .size
          .width,
      borderRadius: BorderRadius.circular(15.r),
      height: height.h,
    ).show(context);
  }

  @override
  goToSearchScreen() {
    Navigator.of(context).push(
      PageAnimationTransition(
        page: const SearchView(),
        pageAnimationType: BottomToTopTransition(),
      ),
    );
  }

  @override
  showMyModalBottomSheetWidget() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          MyBottomSheetWidget(
            title: viewModel.local!.selectPickingImageMethod,
            galleryTitle: viewModel.local!.gallery,
            pickImageFromGallery: viewModel.pickImageFromGallery,
          ),
      backgroundColor: viewModel.themeProvider!.isDark()
          ? MyTheme.blue
          : MyTheme.offWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
        ),
      ),
    );
  }
}