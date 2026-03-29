import 'package:evenrly/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppThemeManager {
  static ThemeData lightTheme () => ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent,elevation: 0,),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.mainText
      ),
      titleMedium: TextStyle(
          fontFamily: "Poppins",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.primary
      ),
      bodyLarge: TextStyle(
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.subText
      ),
      bodyMedium: TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white
      ),
    ),
  );

  static ThemeData darkTheme () => ThemeData(
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.scaffoldDarkBackgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent,elevation: 0,),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          fontFamily: "Poppins",
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.mainDarkText
      ),
      titleMedium: TextStyle(
          fontFamily: "Poppins",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.mainDarkText
      ),
      bodyLarge: TextStyle(
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.subDarkText
      ),
      bodyMedium: TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white
      ),
    ),
  );
}
