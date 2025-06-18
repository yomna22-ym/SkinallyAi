import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../../Domain/Exception/api_exception.dart';
import '../../Domain/Exception/cache_exception.dart';
import '../../Domain/Exception/internet_connection_exception.dart';
import '../../Domain/Exception/permission_denied_exception.dart';
import '../../Domain/Exception/time_out_operations_exception.dart';
import '../../Domain/Exception/url_launcher_exception.dart';
import '../Providers/local_provider.dart';
import '../Providers/theme_provider.dart';
import 'base_navigator.dart';

class BaseViewModel<N extends BaseNavigator> extends ChangeNotifier {
  N? navigator;

  ThemeProvider? themeProvider;
  LocalProvider? localProvider;
  AppLocalizations? local;
  Size? mediaQuery;
  XFile? image;

  @mustCallSuper
  void dispose() {
    navigator = null;
    super.dispose();
  }

  Future<void> pickImageFromGallery() async {
    try {
      navigator?.goBack();
      final ImagePicker picker = ImagePicker();
      var selectedImage = await picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        image = selectedImage;
        notifyListeners();
      }
    } catch (e) {
      navigator?.showErrorNotification(
        message: local?.someThingWentWrong ?? "Something went wrong",
      );
    }
  }

  void showMyModalBottomSheet() {
    navigator?.showMyModalBottomSheetWidget();
  }

  String handleExceptions(Exception e) {
    if (e is CacheException) {
      return local?.unableToLoadDate ?? "Unable to load data";
    } else if (e is ApiException) {
      return e.message;
    } else if (e is InternetConnectionException) {
      return local?.checkYourInternetConnection ??
          "Check your internet connection";
    } else if (e is PermissionDeniedException) {
      return local?.permissionDenied ?? "Permission denied";
    } else if (e is TimeOutOperationsException) {
      return local?.operationTimedOut ?? "Operation timed out";
    } else if (e is URLLauncherException) {
      return local?.urlLaunchingError ?? "URL launching error";
    } else {
      return local?.someThingWentWrong ?? "Something went wrong";
    }
  }
}
