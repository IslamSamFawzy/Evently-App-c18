import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsController extends ChangeNotifier {
  String currentLanguage = 'en';
  ThemeMode currentTheme = ThemeMode.light;

  // 🟢 تحميل الإعدادات
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDark') ?? false;
    final lang = prefs.getString('language') ?? 'en';

    currentTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    currentLanguage = lang;

    notifyListeners();
  }

  // 🟢 تغيير الثيم + حفظه
  Future<void> setCurrentTheme(ThemeMode newTheme) async {
    if (currentTheme == newTheme) return;

    currentTheme = newTheme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', newTheme == ThemeMode.dark);
  }

  // 🟢 تغيير اللغة + حفظها
  Future<void> setCurrentLanguage(String newLanguage) async {
    if (currentLanguage == newLanguage) return;

    currentLanguage = newLanguage;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLanguage);
  }

  bool isDark() => currentTheme == ThemeMode.dark;
  bool isArabic() => currentLanguage == 'ar';
}
