import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '04_sub/grandes_cultures_form.dart';
import '04_sub/legumes_secs_form.dart';
import '04_sub/fourrages_form.dart';
import '04_sub/maraichage_form.dart';
import '04_sub/cultures_industrielles_form.dart';
import '04_sub/arboriculture_form.dart';
import '04_sub/divers_form.dart';
import '04_sub/arbres_epars_form.dart';
import '04_sub/autres_activites_form.dart';

class CulturesFormScreen extends StatelessWidget {
  const CulturesFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _blackTitle(isAr ? '1. المحاصيل الكبرى' : '1. Grandes Cultures'),
              const GrandesCulturesForm(),
              const SizedBox(height: 20),

              _blackTitle(isAr ? '2. البقول الجافة' : '2. Légumes Secs'),
              const LegumesSecsForm(),
              const SizedBox(height: 20),

              _blackTitle(isAr ? '3. المحاصيل العلفية' : '3. Fourrages'),
              const FourragesForm(),
              const SizedBox(height: 20),

              _blackTitle(isAr ? '4. الخضروات' : '4. Maraîchage'),
              const MaraichageForm(),
              const SizedBox(height: 20),

              _blackTitle(
                isAr ? '5. المحاصيل الصناعية' : '5. Cultures Industrielles',
              ),
              const CulturesIndustriellesForm(),
              const SizedBox(height: 20),

              _blackTitle(isAr ? '6. الأشجار المثمرة' : '6. Arboriculture'),
              const ArboricultureForm(),
              const SizedBox(height: 20),

              _blackTitle(isAr ? '7. محاصيل متنوعة' : '7. Divers'),
              const DiversForm(),
              const SizedBox(height: 20),

              _blackTitle(isAr ? '8. أشجار مبعثرة' : '8. Arbres Epars'),
              const ArbresEparsForm(),
              const SizedBox(height: 20),

              _blackTitle(isAr ? '9. أنشطة أخرى' : '9. Autres Activités'),
              const AutresActivitesForm(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blackTitle(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
