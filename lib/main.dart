import 'package:evenrly/core/config/routes/app_routes.dart';
import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_theme_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeManager.lightTheme(),
      darkTheme: AppThemeManager.darkTheme(),
      themeMode: ThemeMode.light,
      initialRoute: PagesRouteName.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

