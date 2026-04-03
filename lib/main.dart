import 'package:evenrly/core/config/routes/app_routes.dart';
import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_theme_manager.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettingsController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appSettingsController = Provider.of<AppSettingsController>(
      context,
    );
    return MaterialApp(
      theme: AppThemeManager.lightTheme(),
      darkTheme: AppThemeManager.darkTheme(),
      themeMode: appSettingsController.currentTheme,
      initialRoute: PagesRouteName.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      locale: Locale(appSettingsController.currentLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
