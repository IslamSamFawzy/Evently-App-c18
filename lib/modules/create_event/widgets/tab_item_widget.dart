import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:evenrly/models/category_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TabItemWidget extends StatelessWidget {
  final CategoryData data;
  final bool isSelected;

  const TabItemWidget({
    super.key,
    required this.data,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: provider.isDark() ? isSelected ? AppColors.primaryDark : AppColors.scaffoldDarkBackgroundColor : isSelected ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: provider.isDark() ? AppColors.strokeBorder : AppColors.strokeColor),
      ),
      child: Row(
        spacing: 4,
        children: [
          SvgPicture.asset(
            data.icon,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(provider.isDark() ? isSelected ? Colors.white : AppColors.primaryDark :
              isSelected ? Colors.white : AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          Text(
            data.name,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: provider.isDark() ? isSelected ? Colors.white : Colors.white : isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
