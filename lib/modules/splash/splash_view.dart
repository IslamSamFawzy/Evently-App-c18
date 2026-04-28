import 'dart:async';

import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/gen/assets.gen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  Future<void> navigate() async {
    final prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('onboarding_seen') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (seen) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PagesRouteName.signIn,
            (route) => false,
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        PagesRouteName.onBoardingConfig,
            (route) => false,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Assets.images.eventlyLogoImg.image(color: theme.primaryColor),
      ),
    );
  }
}
