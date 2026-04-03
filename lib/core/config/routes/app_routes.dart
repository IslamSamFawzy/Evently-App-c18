import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:flutter/material.dart';
import '../../../modules/on_boarding/on_boarding_view.dart';
import '../../../modules/splash/splash_view.dart';

abstract class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PagesRouteName.initial:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
          settings: settings,
        );
      case PagesRouteName.onBoardingConfig:
        return MaterialPageRoute(
          builder: (_) => const OnBoardingView(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
          settings: settings,
        );
    }
  }
}
