import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:evenrly/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class SelectTheme extends StatelessWidget {
  const SelectTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            'Theme',
            style: theme.textTheme.titleMedium,
          ),
        ),
        Container(
          width: 80,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Assets.icons.sun.svg(),
        ),
        SizedBox(width: 8,),
        Container(
          width: 80,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Assets.icons.moon.svg(),
        ),
      ],
    );
  }
}
