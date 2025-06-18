import '../../../Core/Base/base_navigator.dart';

abstract class PharmacyNavigator extends BaseNavigator {
  void goToProductDetails(String productId);
  void showProductBottomSheet(dynamic product);
}