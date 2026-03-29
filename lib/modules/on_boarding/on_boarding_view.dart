import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/modules/on_boarding/widgets/select_language.dart';
import 'package:evenrly/modules/on_boarding/widgets/select_theme.dart';
import 'package:flutter/material.dart';

import '../../core/gen/assets.gen.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Assets.images.eventlyLogoImg.image(width: 142)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Assets.images.onBoardingConfigImg.image(),
            Text(
              'Personalize Your Experience',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              "Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.",
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            SelectLanguage(),
            SizedBox(height: 18),
            SelectTheme(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Let’s start',
                style: theme.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
