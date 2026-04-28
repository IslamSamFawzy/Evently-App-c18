import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/models/event_data.dart';
import 'package:evenrly/modules/authentication/sign_in/sign_in_view.dart';
import 'package:evenrly/modules/authentication/sign_up/sign_up_view.dart';
import 'package:evenrly/modules/create_event/create_event_view.dart';
import 'package:evenrly/modules/forget_password/forget_password_view.dart';
import 'package:evenrly/modules/layout/home/widgets/event_details_view.dart';
import 'package:evenrly/modules/layout/home/widgets/update_event_view.dart';
import 'package:evenrly/modules/layout/layout_view.dart';
import 'package:evenrly/modules/on_boarding/on_boarding2.dart';
import 'package:evenrly/modules/on_boarding/on_boarding3.dart';
import 'package:evenrly/modules/on_boarding/on_boarding4.dart';
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
        case PagesRouteName.signIn:
          return MaterialPageRoute(
            builder: (_) => const SignInView(),
            settings: settings,
          );
        case PagesRouteName.signUp:
          return MaterialPageRoute(
            builder: (_) => const SignUpView(),
            settings: settings,
          );
      case PagesRouteName.home:
        return MaterialPageRoute(
          builder: (_) => const LayoutView(),
          settings: settings,
        );
      case PagesRouteName.createEvent:
        return MaterialPageRoute(
          builder: (_) => const CreateEventView(),
          settings: settings,
        );
      case PagesRouteName.onBoarding2:
        return MaterialPageRoute(
          builder: (_) => const OnBoarding2(),
          settings: settings,
        );
      case PagesRouteName.onBoarding3:
        return MaterialPageRoute(
          builder: (_) => const OnBoarding3(),
          settings: settings,
        );
      case PagesRouteName.onBoarding4:
        return MaterialPageRoute(
          builder: (_) => const OnBoarding4(),
          settings: settings,
        );
      case PagesRouteName.forgetPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordView(),
          settings: settings,
        );
      case PagesRouteName.eventDetails:
        final eventData = settings.arguments as EventData;

        return MaterialPageRoute(
          builder: (_) => EventDetailsView(eventData: eventData),
          settings: settings,
        );
      case PagesRouteName.updateEvent:
        final eventData = settings.arguments as EventData;
        return MaterialPageRoute(
          builder: (_) => UpdateEventView(eventData: eventData),
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
