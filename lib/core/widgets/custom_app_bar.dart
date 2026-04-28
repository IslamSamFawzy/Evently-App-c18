import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppSettingsController>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: provider.isDark() ? AppColors.unSelectedItem : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: provider.isDark()
                ? AppColors.strokeBorder
                : AppColors.strokeColor,
          ),
        ),
        child: provider.isArabic()
            ? Assets.images.arrowRight.image(
                color:
                  provider.isDark() ? Colors.white : AppColors.primary,
              )
            : Assets.icons.arrowLeft.svg(
                colorFilter: ColorFilter.mode(
                  provider.isDark() ? Colors.white : AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }
}
