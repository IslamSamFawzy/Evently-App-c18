import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTheme extends StatelessWidget {
  const SelectTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AppSettingsController>(
      builder: (context, provider, _) {
        return Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.theme,
                style: theme.textTheme.titleMedium,
              ),
            ),
            GestureDetector(
              onTap: () {
                provider.setCurrentTheme(ThemeMode.light);
              },
              child: Container(
                width: 80,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: provider.currentTheme == ThemeMode.light
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
                child: provider.isDark()
                    ? Assets.icons.sunUnfilled.svg(
                        colorFilter: ColorFilter.mode(
                          provider.currentTheme == ThemeMode.light
                              ? Colors.white
                              : provider.isDark()
                              ? Colors.white
                              : theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Assets.icons.sun.svg(
                        colorFilter: ColorFilter.mode(
                          provider.currentTheme == ThemeMode.light
                              ? Colors.white
                              : provider.isDark()
                              ? Colors.white
                              : theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                provider.setCurrentTheme(ThemeMode.dark);
              },
              child: Container(
                width: 80,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: provider.currentTheme == ThemeMode.dark
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
                child: provider.isDark()
                    ? Assets.icons.moonFilled.svg(
                        colorFilter: ColorFilter.mode(
                          provider.currentTheme == ThemeMode.dark
                              ? Colors.white
                              : provider.isDark()
                              ? Colors.white
                              : theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Assets.icons.moon.svg(
                        colorFilter: ColorFilter.mode(
                          provider.currentTheme == ThemeMode.dark
                              ? Colors.white
                              : provider.isDark()
                              ? Colors.white
                              : theme.primaryColor,
                          BlendMode.srcIn,
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
