import 'package:evenrly/core/config/routes/pages_route_name.dart';
import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/widgets/custom_app_bar.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/provider/app_settings_controller.dart';

class OnBoarding3 extends StatelessWidget {
  const OnBoarding3({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Assets.images.eventlyLogoImg.image(
          width: 142,
          color: theme.primaryColor,
        ),
        centerTitle: true,
        leading: CustomAppBar(),
        actions: [
          GestureDetector(
            onTap: () async{
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboarding_seen', true);
              Navigator.pushNamedAndRemoveUntil(
                context,
                PagesRouteName.signIn,
                    (route) => false,
              );
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: provider.isDark()
                    ? AppColors.unSelectedItem
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: provider.isDark()
                      ? AppColors.strokeBorder
                      : AppColors.strokeColor,
                ),
              ),
              child: Text(
                local.skip,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Assets.images.beingCreative.image(
              color: provider.isDark() ? Colors.white : theme.primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.effortless_event_planning,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.description_two,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, PagesRouteName.onBoarding4);
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
                  AppLocalizations.of(context)!.next,
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
