import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Core/Providers/local_provider.dart';
import 'Core/Providers/location_provider.dart';
import 'Core/Providers/theme_provider.dart';
import 'Core/Theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Core/routes_manager/routes_generator.dart';
import 'core/routes_manager/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  final bool firstTime = sharedPrefs.getBool("firstTime") ?? true;
  final bool loggedIn = sharedPrefs.getBool("loggedIn") ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocalProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        // ChangeNotifierProvider(create: (_) => ClinicsViewModel()),
      ],
      child: MyApp(
        initialRouteArguments: {
          'firstTime': firstTime,
          'loggedIn': loggedIn,
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Map<String, bool> initialRouteArguments;

  MyApp({super.key, required this.initialRouteArguments});

  late ThemeProvider themeProvider;
  late LocalProvider localProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    localProvider = Provider.of<LocalProvider>(context);
    setTheme();
    setLocal();

    return ScreenUtilInit(
      designSize: const Size(393, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'SkinallyAi',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale(localProvider.getLocal()),
          supportedLocales: AppLocalizations.supportedLocales,

          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: Routes.splashRoute,
          onGenerateInitialRoutes: (initialRouteName) {
            return [
              RouteGenerator.getRoute(RouteSettings(
                name: initialRouteName,
                arguments: initialRouteArguments,
              )),
            ];
          },
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          themeMode: themeProvider.getTheme(),
        );
      },
    );
  }

  Future<void> setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var theme = prefs.getString("theme");
    themeProvider.changeTheme(
      theme == "Dark" || theme == null ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> setLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var local = prefs.getString("local");
    localProvider.changeLocal(local ?? "en");
  }
}
