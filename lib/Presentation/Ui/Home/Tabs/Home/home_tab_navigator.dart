import '../../../../../Core/Base/base_navigator.dart';

abstract class HomeTabNavigator extends BaseNavigator {
  void navigateToPharmacyView();
  void navigateToCategoriesView();
  void navigateToCategoryDetails(dynamic category);
  void showErrorMessage(String message);
}
