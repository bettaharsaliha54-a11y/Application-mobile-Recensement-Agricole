import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../core/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الجمهورية (لغة واحدة فقط)
              Text(
                lang.isArabic
                    ? 'الجمهورية الجزائرية الديمقراطية الشعبية'
                    : 'République Algérienne Démocratique et Populaire',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.primaryGreen.withOpacity(0.8),
                  fontSize: 24, // أكبر للجمهورية
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.isArabic
                    ? 'وزارة الفلاحة والتنمية الريفية'
                    : 'Ministère de l\'Agriculture et du Développement Rural',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 20, // أصغر للوزارة
                  fontWeight: FontWeight.w900,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.eco_rounded,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 20),

              Text(
                lang.isArabic
                    ? 'الإحصاء العام للفلاحة'
                    : 'Recensement Agricole',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),

              // اختيار اللغة (مختصر)
              Text(
                lang.t('اختر اللغة', 'Choisir la langue'),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<LanguageProvider>().setArabic(true);
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('العربية'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<LanguageProvider>().setArabic(false);
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Français'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
