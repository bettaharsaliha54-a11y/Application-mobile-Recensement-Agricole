import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_superficie_table.dart';

class SuperficiesTableForm extends StatelessWidget {
  const SuperficiesTableForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> surfaceOptions = [
      {'ar': 'المحاصيل العشبية', 'fr': 'Cultures herbacées'},
      {'ar': 'أراضي مستريحة (بور)', 'fr': 'Terres au repos (jachères)'},
      {'ar': 'محاصيل دائمة (مغروسات)', 'fr': 'Cultures pérennes'},
      {'ar': 'مروج طبيعية', 'fr': 'Prairies naturelles'},
      {'ar': 'المراعي', 'fr': 'Pacages et parcours'},
      {'ar': 'مساحات غير منتجة', 'fr': 'Surfaces improductives'},
      {'ar': 'أراضي الغابات', 'fr': 'Terres forestières'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicSuperficieTable(
            titleAr: 'توزيع مساحات المستثمرة',
            titleFr: 'Répartition des superficies',
            prefix: 'sf',
            options: surfaceOptions,
            addTextAr: 'إضافة نوع مساحة',
            addTextFr: 'Ajouter un type de surface',
          ),
        ],
      ),
    );
  }
}
