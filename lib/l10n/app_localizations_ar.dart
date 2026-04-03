// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get personalize_your_experience => 'خصص تجربتك';

  @override
  String get personalize_your_experience_desc =>
      'اختر المظهر واللغة المفضلين لديك لتبدأ بتجربة مريحة ومناسبة لأسلوبك.';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'المظهر';

  @override
  String get lets_start => 'لنبدأ';
}
