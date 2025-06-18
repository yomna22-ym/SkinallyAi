import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class BaseNavigator {
  void showLoading({required String message});

  void showFailMessage({
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  });

  void showSuccessMessage({
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  });

  void showQuestionMessage({
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negativeActionTitle,
    VoidCallback? negativeAction,
  });

  void goBack();

  void goToSearchScreen();

  void showErrorNotification({required String message});

  void showSuccessNotification({required String message});

  void showCustomNotification({
    required IconData iconData,
    required String message,
    required Color background,
    required double height,
  });

  void showMyModalBottomSheetWidget();
}
