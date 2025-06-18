import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinally_aii/Core/routes_manager/routes.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Services/services_tab_navigator.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Services/services_tab_view_model.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Services/widgets/services_card_widget.dart';

import '../../../../../Core/Base/base_state.dart';
import '../../../../../Core/Theme/theme.dart';

class ServicesTabView extends StatefulWidget {
  const ServicesTabView({super.key});

  @override
  State<ServicesTabView> createState() => _ServicesTabViewState();
}

class _ServicesTabViewState extends BaseState<ServicesTabView, ServicesTabViewModel>
    implements ServicesTabNavigator {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initIfNeeded();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel.initIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final local = viewModel.local;
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Consumer<ServicesTabViewModel>(
              builder: (context, vm, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    // Title
                    Text(
                      local!.ourServices,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: viewModel.themeProvider!.isDark() ? MyTheme.white : MyTheme.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Subtitle
                    Text(
                      local.servicesDescription,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 60.h),
                    // Services list
                    if (vm.isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (vm.servicesData.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            "No services available",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20.sp),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: vm.servicesData.length,
                            separatorBuilder: (_, __) => SizedBox(height: 40.h),
                            itemBuilder: (context, index) {
                              final service = vm.servicesData[index];
                              return ServiceCardWidget(service: service);
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  ServicesTabViewModel initViewModel() => ServicesTabViewModel();

  @override
  void goToClinicsScreen() => Navigator.pushNamed(context, Routes.clinicsRoute);

  @override
  void goToBlogNewsScreen() => Navigator.pushNamed(context, Routes.blogNewsRoute);

  @override
  void goToPharmacyScreen() => Navigator.pushNamed(context, Routes.pharmacyRoute);
}

