import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            'Language',
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
          child: Text('English',style: theme.textTheme.bodyMedium,),
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
          child: Text('Arabic',style: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.primary,
          ),),
        ),
      ],
    );
  }
}
