import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/utils/provider/app_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomContainerButton extends StatelessWidget {
  final String text;
  final String svgPic;
  final void Function()? onTap;

  const CustomContainerButton({super.key, required this.text, required this.svgPic, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppSettingsController>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: provider.isDark()
                ? AppColors.unSelectedItem
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: provider.isDark()
                  ? AppColors.strokeBorder
                  : AppColors.strokeColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text,style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500
                ),),
                SvgPicture.asset(svgPic),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
