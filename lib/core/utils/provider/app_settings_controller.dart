import 'package:flutter/material.dart';

class AppSettingsController extends ChangeNotifier{
  String currentLanguage = 'en';
  ThemeMode currentTheme = ThemeMode.light;



  void setCurrentTheme(ThemeMode newTheme){
    if(currentTheme == newTheme) return;
    currentTheme = newTheme;
    notifyListeners();
  }

  void setCurrentLanguage(String newLanguage){
    if(currentLanguage == newLanguage) return;
    currentLanguage = newLanguage;
    notifyListeners();
  }

  bool isDark () => currentTheme == ThemeMode.dark;

}