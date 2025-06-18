import '../../../../../Core/Base/base_navigator.dart';

abstract class CategoryNavigator extends BaseNavigator {
  void navigateToDetails(int categoryId);
  void navigateToSearch();
  void showCategoryImages(List<String> images, int initialIndex);
  void shareCategory(String categoryName);
  void bookmarkCategory(int categoryId);
}