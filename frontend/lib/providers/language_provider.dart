import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  bool _isArabic = true; // نفضل العربية كخيار افتراضي

  bool get isArabic => _isArabic;

  void setArabic(bool value) {
    _isArabic = value;
    notifyListeners();
  }

  // دالة مساعدة للترجمة السريعة
  String t(String ar, String fr) {
    return _isArabic ? ar : fr;
  }
}
