import 'package:flutter/material.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Services/services_tab_navigator.dart';

import '../../../../../Core/Base/base_view_model.dart';
import '../../../../Models/services_card.dart';

class ServicesTabViewModel extends BaseViewModel<ServicesTabNavigator> {
  List<ServiceCard> servicesData = [];
  bool isLoading = true;

  void initIfNeeded() {
    if (servicesData.isNotEmpty) return;

    if (local == null) {
      isLoading = true;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();


    servicesData = [
      ServiceCard(
        id: 0,
        title: local!.clinics,
        subtitle: local!.clinicsSubtitle,
        imageUrl: 'Assets/Images/clinics.jpg',
        onClickListener: goToClinicsScreen,
      ),
      ServiceCard(
        id: 1,
        title: local!.news,
        subtitle: local!.newsSubtitle,
        imageUrl: 'Assets/Images/news.jpg',
        onClickListener: goToBlogNewsScreen,

      ),
      ServiceCard(
        id: 2,
        title: local!.pharmacy,
        subtitle: local!.pharmacySubtitle,
        imageUrl: 'Assets/Images/pharmacy.jpg',
        onClickListener: goToPharmacyScreen,
      ),
    ];

    isLoading = false;
    notifyListeners();
  }

  void goToClinicsScreen() => navigator?.goToClinicsScreen();
  void goToBlogNewsScreen() => navigator?.goToBlogNewsScreen();
  void goToPharmacyScreen() => navigator?.goToPharmacyScreen();
}
