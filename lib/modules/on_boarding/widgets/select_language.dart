import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //var appSettingsController = Provider.of<AppSettingsController>(context,listen: false);
    return Consumer<AppSettingsController>(
      builder: (context, provider, _) {
        return Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.language,
                style: theme.textTheme.titleMedium,
              ),
            ),
            GestureDetector(
              onTap: () {
                provider.setCurrentLanguage('en');
              },
              child: Container(
                width: 80,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: provider.currentLanguage == 'en'
                      ? theme.primaryColor
                      : provider.isDark()
                      ? AppColors.unSelectedItem
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: provider.isDark()
                        ? AppColors.strokeBorder
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.english,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: provider.currentLanguage == 'en'
                        ? Colors.white
                        : provider.isDark()
                        ? Colors.white
                        : theme.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                provider.setCurrentLanguage('ar');
              },
              child: Container(
                width: 80,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: provider.currentLanguage == 'ar'
                      ? theme.primaryColor
                      : provider.isDark()
                      ? AppColors.unSelectedItem
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: provider.isDark()
                        ? AppColors.strokeBorder
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.arabic,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: provider.currentLanguage == 'ar'
                        ? Colors.white
                        : provider.isDark()
                        ? Colors.white
                        : theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
