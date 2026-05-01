import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ألوان فلاحية عصرية (Forest & Gold)
  static const Color primaryGreen = Color(0xFF1B5E20); // أخضر غامق ملكي
  static const Color primaryForestGreen = Color(0xFF2E7D32); // أخضر فلاحي
  static const Color accentGold = Color(0xFFFFD600); // ذهبي ساطع للتمييز
  static const Color backgroundLight = Color(
    0xFFF1F8E9,
  ); // خلفية خضراء ناعمة جداً
  static const Color textPrimary = Color(0xFF1B5E20);
  static const Color textSecondary = Color(0xFF757575);
  static const Color surfaceLight = Color(0xFFFBFBFB);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: accentGold,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,

      // الخطوط الضخمة والواضحة (Cairo) برؤية معاصرة
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: primaryGreen,
          height: 1.2,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryGreen,
        ),
        bodyLarge: GoogleFonts.cairo(fontSize: 16, color: Colors.black87),
      ),

      // ستايل ثابت للأزرار (Medium Size) بحجم متوسط وأنيق
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ), // حجم متوسط
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ), // حجم متوسط
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
