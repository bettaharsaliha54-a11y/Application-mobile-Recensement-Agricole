import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/questionnaire_provider.dart';
import '06_sub/dynamic_water_table.dart';

class EauIrrigationFormScreen extends StatelessWidget {
  const EauIrrigationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> gpiOptions = [
      {'ar': 'سد', 'fr': 'Barrage'},
      {'ar': 'محطة معالجة مياه الصرف الصحي', 'fr': 'Station d\'épuration'},
      {'ar': 'مجموعة آبار عميقة', 'fr': 'Ensemble de forages'},
    ];

    const List<Map<String, String>> pmhOptions = [
      {'ar': 'بئر', 'fr': 'Puits'},
      {'ar': 'بئر عميق', 'fr': 'Forage'},
      {'ar': 'ضخ من الوادي', 'fr': 'Pompage d\'Oued'},
      {'ar': 'فيض الوادي', 'fr': 'Crues d\'oued'},
      {'ar': 'سد صغير', 'fr': 'Petit barrage'},
      {'ar': 'خزان التلال', 'fr': 'Retenu collinaire'},
      {'ar': 'الفقارة', 'fr': 'Foggara'},
      {'ar': 'منبع', 'fr': 'Source'},
      {'ar': 'محطة معالجة مياه الصرف', 'fr': 'Station d\'épuration'},
      {'ar': 'مصادر أخرى', 'fr': 'Autres'},
    ];

    const List<Map<String, String>> modeOptions = [
      {'ar': 'الرش الكلاسيكي', 'fr': 'Aspersion classique'},
      {'ar': 'السطحي', 'fr': 'Gravitaire'},
      {'ar': 'الفيض', 'fr': 'Epandage de crues'},
      {'ar': 'التقطير', 'fr': 'Goutte à goutte'},
      {'ar': 'الرش المحوري', 'fr': 'Pivots'},
      {'ar': 'اللفاف', 'fr': 'Enrouleur'},
      {'ar': 'الأمطار الاصطناعية', 'fr': 'Pluie artificielle'},
      {'ar': 'فقارة', 'fr': 'Foggara'},
      {'ar': 'طرق أخرى', 'fr': 'Autre'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. نوع المصدر
              _blackTitle(isAr ? '1. نوع المصدر' : '1. Type d\'ouvrage'),
              const SizedBox(height: 12),

              DynamicWaterTable(
                titleAr: 'محيطات ري الكبرى',
                titleFr: 'Grands Périmètres d\'Irrigation',
                prefix: 'water_gpi',
                options: gpiOptions,
                addTextAr: 'إضافة منشأة الكبرى',
                addTextFr: 'Ajouter ouvrage',
                col2Ar: 'العدد',
                col2Fr: 'Nombre',
              ),

              const SizedBox(height: 16),

              DynamicWaterTable(
                titleAr: 'محيطات الري المتوسطة والصغرى',
                titleFr: 'Petite et Moyenne Hydraulique',
                prefix: 'water_pmh',
                options: pmhOptions,
                addTextAr: 'إضافة منشأة صغرى',
                addTextFr: 'Ajouter ouvrage',
                col2Ar: 'العدد',
                col2Fr: 'Nombre',
              ),

              const SizedBox(height: 24),

              // 2. طريقة الري
              _blackTitle(isAr ? '2. طريقة الري' : '2. Mode d\'irrigation'),
              const SizedBox(height: 12),
              DynamicWaterTable(
                titleAr: 'توزيع المساحة حسب طريقة الري',
                titleFr: 'Superficie par mode d\'irrigation',
                prefix: 'water_mode',
                options: modeOptions,
                addTextAr: 'إضافة وسيلة ري',
                addTextFr: 'Ajouter mode',
                col2Ar: 'المساحة (هـ)',
                col2Fr: 'Superficie (Ha)',
              ),

              const SizedBox(height: 24),

              // 3. طريقة تخزين المياه
              _blackTitle(
                isAr
                    ? '3. طريقة تخزين المياه'
                    : '3. Mode de stockage de l\'eau',
              ),
              const SizedBox(height: 12),
              _fieldCard([
                _gridCheckboxes([
                  _checkItem(
                    'st_bassin',
                    isAr ? 'أحواض التجميع' : 'Bassin d\'accumulation',
                    prov,
                  ),
                  _checkItem(
                    'st_geomem',
                    isAr ? 'الأحواض المائية الأرضية' : 'Bassin géomembrane',
                    prov,
                  ),
                  _checkItem('st_reserv', isAr ? 'خزان' : 'Réservoir', prov),
                  _checkItem(
                    'st_citerne',
                    isAr ? 'صهريج مرن' : 'Citerne souple',
                    prov,
                  ),
                  _checkItem(
                    'st_mare',
                    isAr ? 'بركة الماء' : 'Mare d\'eau',
                    prov,
                  ),
                  _checkItem('st_gad', isAr ? 'سد الماء' : 'Gad', prov),
                  _checkItem('st_digue', isAr ? 'حاجز الماء' : 'Digue', prov),
                  _checkItem('st_autres', isAr ? 'طرق أخرى' : 'Autres', prov),
                ], cols: 2),
              ]),

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

  Widget _fieldCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _gridCheckboxes(List<Widget> items, {int cols = 1}) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: items.map((e) => SizedBox(width: 155, child: e)).toList(),
    );
  }

  Widget _checkItem(String key, String label, QuestionnaireProvider prov) {
    const green = Color(0xFF2E7D32);
    final bool val = prov.values[key] == true;
    return InkWell(
      onTap: () => prov.updateValue(key, !val),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: val ? green : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: val ? green : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: val
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
