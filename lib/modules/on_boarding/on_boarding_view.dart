import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:evenrly/modules/on_boarding/widgets/select_language.dart';
import 'package:evenrly/modules/on_boarding/widgets/select_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/gen/assets.gen.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Assets.images.eventlyLogoImg.image(width: 142,color: theme.primaryColor)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Assets.images.onBoardingConfigImg.image(color: provider.isDark() ? Colors.white : theme.primaryColor),
            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.personalize_your_experience,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.personalize_your_experience_desc,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  AppLocalizations.of(context)!.lets_start,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
