import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/widgets/custom_app_bar.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/provider/app_settings_controller.dart';

class OnBoarding4 extends StatelessWidget {
  const OnBoarding4({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Assets.images.eventlyLogoImg.image(
          width: 142,
          color: theme.primaryColor,
        ),
        centerTitle: true,
        leading: CustomAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Assets.images.beingCreative2.image(
              color: provider.isDark() ? Colors.white : theme.primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.connect_with_friends_share_moments,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.description_three,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            Spacer(),
            ElevatedButton(
              onPressed: () async{
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('onboarding_seen', true);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  PagesRouteName.signIn,
                      (route) => false,
                );
              },
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
                  AppLocalizations.of(context)!.get_started,
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
